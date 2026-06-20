//
//  RealityViewer.swift
//  Zomato — "Reality mode" dish photos
//
//  The dish detail sheet. The photo card is a compare slider — menu photo
//  on the left, a diner's delivery photo on the right, 50/50 by default.
//  Tap any photo in the film-strip to load it into the comparison.
//

import SwiftUI

struct RealityViewer: View {
    let dish: Dish
    @Environment(\.dismiss) private var dismiss

    @State private var quantity = 1
    @State private var showGallery = false
    @State private var selectedDinerPhoto: CrowdPhoto?
    @State private var showToast = false
    @State private var toastWorkItem: DispatchWorkItem?

    private var stripPhotos: [CrowdPhoto] {
        CrowdPhoto.photos(for: dish, count: min(7, dish.photoCount))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    RealitySlider(dish: dish, dinerPhoto: selectedDinerPhoto)
                        .aspectRatio(1.30, contentMode: .fit)
                        .padding(12)

                    titleBlock
                    realityRow
                    if dish.photoAccuracy != nil { consensusChips }
                    thumbStrip
                    uploadButton
                }
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            addBar
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        .overlay(alignment: .topTrailing) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(.black.opacity(0.55)))
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
            .padding(.trailing, 20)
        }
        .overlay(alignment: .top) {
            if showToast { goldToast }
        }
        .sheet(isPresented: $showGallery) {
            CrowdGalleryView(dish: dish)
        }
    }

    // MARK: Title block (matches the real dish sheet)

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VegMark(size: 17)
                Spacer()
                RoundIconButton(systemName: "bookmark")
                RoundIconButton(systemName: "arrowshape.turn.up.right")
            }
            Text(dish.name)
                .font(ZTheme.heading(21, .bold))
                .foregroundStyle(ZTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            if dish.highlyReordered {
                HStack(spacing: 6) {
                    Capsule().fill(ZTheme.ratingGreen)
                        .frame(width: 34, height: 11)
                        .overlay(alignment: .trailing) {
                            Capsule().fill(Color(red: 0.85, green: 0.90, blue: 0.86))
                                .frame(width: 9, height: 11)
                        }
                    Text("Highly reordered")
                        .font(.system(size: 13.5, weight: .medium))
                        .foregroundStyle(ZTheme.ink2)
                }
            }

            Text(dish.blurb)
                .font(.system(size: 13.5))
                .foregroundStyle(ZTheme.ink2)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }

    // MARK: Reality row — score ring or early-days

    private var realityRow: some View {
        Button { showGallery = true } label: {
            HStack(spacing: 14) {
                if let accuracy = dish.photoAccuracy {
                    AccuracyRing(accuracy: accuracy, color: dish.accuracyColor)
                } else {
                    earlyDaysRing
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(dish.photoAccuracy != nil ? "Photo accuracy" : "Early days")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(ZTheme.ink)
                    Text(dish.photoAccuracy != nil
                         ? "Rated by \(dish.photoCount) diners who got it delivered"
                         : "\(dish.photoCount) photos so far. Order and be the first to add one.")
                        .font(.system(size: 12))
                        .foregroundStyle(ZTheme.ink3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ZTheme.ink3)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(.white))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.top, 16)
    }

    private var earlyDaysRing: some View {
        Circle()
            .strokeBorder(ZTheme.ink3.opacity(0.5),
                          style: StrokeStyle(lineWidth: 4, dash: [4, 5]))
            .frame(width: 56, height: 56)
            .overlay {
                Text("—")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(ZTheme.ink3)
            }
    }

    // MARK: Consensus chips

    private var consensusChips: some View {
        ScrollView(.horizontal) {
            ConsensusChipsRow(items: [
                ("flame", "Arrives hot \(dish.arrivesHot)%"),
                ("shippingbox", "Spill-proof \(dish.spillProof)%"),
                ("camera.viewfinder", "Looks like photo \(dish.looksLikePhoto)%"),
            ])
            .padding(.horizontal, 12)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 10)
    }

    // MARK: Diner photo strip → loads into the slider

    private var thumbStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tap a photo to compare it with the menu shot")
                .font(.system(size: 12.5, weight: .medium))
                .foregroundStyle(ZTheme.ink3)
                .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(stripPhotos) { photo in
                        Button {
                            withAnimation(.spring(duration: 0.45, bounce: 0.25)) {
                                selectedDinerPhoto = photo.id == selectedDinerPhoto?.id ? nil : photo
                            }
                        } label: {
                            CrowdPhotoTile(photo: photo, showsStamp: false)
                                .frame(width: 84, height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(ZTheme.red,
                                                      lineWidth: photo.id == selectedDinerPhoto?.id ? 2.5 : 0)
                                )
                                .scaleEffect(photo.id == selectedDinerPhoto?.id ? 0.94 : 1)
                        }
                        .buttonStyle(.plain)
                    }
                    Button { showGallery = true } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 16))
                            Text("All \(dish.photoCount)")
                                .font(.system(size: 11.5, weight: .semibold))
                        }
                        .foregroundStyle(ZTheme.ink2)
                        .frame(width: 84, height: 84)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.white))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 16)
        .sensoryFeedback(.selection, trigger: selectedDinerPhoto?.id)
    }

    // MARK: Upload mock + Gold toast

    private var uploadButton: some View {
        Button {
            triggerToast()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "camera")
                    .font(.system(size: 13, weight: .semibold))
                Text("Add your delivery photo")
                    .font(.system(size: 14.5, weight: .semibold))
            }
            .foregroundStyle(ZTheme.red)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(ZTheme.red.opacity(0.55), lineWidth: 1.2)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .sensoryFeedback(.success, trigger: showToast) { _, now in now }
    }

    private func triggerToast() {
        toastWorkItem?.cancel()
        withAnimation(.spring(duration: 0.45, bounce: 0.3)) { showToast = true }
        let item = DispatchWorkItem {
            withAnimation(.easeIn(duration: 0.25)) { showToast = false }
        }
        toastWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: item)
    }

    private var goldToast: some View {
        GoldToast()
            .transition(.move(edge: .top).combined(with: .opacity))
            .padding(.top, 14)
    }

    // MARK: Add bar (matches the real sheet's bottom bar)

    private var addBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                stepperButton("minus") { if quantity > 1 { quantity -= 1 } }
                Text("\(quantity)")
                    .font(.system(size: 17, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(ZTheme.ink)
                    .frame(minWidth: 30)
                stepperButton("plus") { quantity += 1 }
            }
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 0.94, green: 0.98, blue: 0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(ZTheme.ratingGreen.opacity(0.35), lineWidth: 1)
            )

            Button {} label: {
                HStack(spacing: 6) {
                    Text("Add item -")
                    if let strike = dish.strikePrice {
                        Text("₹\(strike * quantity)").strikethrough()
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    Text("₹\(dish.price * quantity)")
                }
                .font(.system(size: 16.5, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(red: 0.10, green: 0.55, blue: 0.25))
                )
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.impact(weight: .medium), trigger: quantity)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.white)
        .overlay(alignment: .top) { Rectangle().fill(ZTheme.hairline).frame(height: 1) }
    }

    private func stepperButton(_ name: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(ZTheme.ratingGreen)
                .frame(width: 40, height: 50)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Accuracy ring (fills + counts up on appear)

struct AccuracyRing: View {
    let accuracy: Double
    let color: Color

    @State private var fill: CGFloat = 0
    @State private var displayed: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: 5)
            Circle()
                .trim(from: 0, to: fill)
                .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
            HStack(spacing: 1) {
                Text(String(format: "%.1f", displayed))
                    .font(.system(size: 14, weight: .heavy))
                    .monospacedDigit()
                    .contentTransition(.numericText(value: displayed))
                Image(systemName: "star.fill")
                    .font(.system(size: 7, weight: .bold))
            }
            .foregroundStyle(color)
        }
        .frame(width: 56, height: 56)
        .task {
            withAnimation(.easeOut(duration: 0.8)) { fill = accuracy / 5 }
            let steps = 16
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.linear(duration: 0.05)) {
                    displayed = accuracy * Double(i) / Double(steps)
                }
            }
            displayed = accuracy
        }
        .accessibilityLabel("Photo accuracy \(String(format: "%.1f", accuracy)) out of 5")
    }
}

// MARK: - Consensus chips (staggered entrance)

struct ConsensusChipsRow: View {
    let items: [(icon: String, label: String)]
    @State private var appeared = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { i, item in
                HStack(spacing: 5) {
                    Image(systemName: item.icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(ZTheme.ink2)
                    Text(item.label)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(ZTheme.ink)
                        .fixedSize()
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color(red: 0.94, green: 0.94, blue: 0.95)))
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 8)
                .animation(.spring(duration: 0.4, bounce: 0.2).delay(Double(i) * 0.08),
                           value: appeared)
            }
        }
        .onAppear { appeared = true }
    }
}

// MARK: - Gold points toast

struct GoldToast: View {
    @State private var spin: Double = 0

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(red: 0.95, green: 0.80, blue: 0.40),
                                                  Color(red: 0.80, green: 0.62, blue: 0.22)],
                                         startPoint: .top, endPoint: .bottom))
                Text("₹")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Color(red: 0.45, green: 0.33, blue: 0.08))
            }
            .frame(width: 26, height: 26)
            .rotation3DEffect(.degrees(spin), axis: (x: 0, y: 1, z: 0))

            VStack(alignment: .leading, spacing: 1) {
                Text("+50 Gold points")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ZTheme.ink)
                Text("Your photo was added to this dish")
                    .font(.system(size: 12))
                    .foregroundStyle(ZTheme.ink3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(
            Capsule().fill(.white)
                .shadow(color: .black.opacity(0.18), radius: 12, y: 4)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { spin = 360 }
        }
    }
}

// MARK: - Compare slider
//
// Menu photo left of the divider, diner photo right. Opens 50/50.
// Rests wherever released; settles to an edge only when close.

struct RealitySlider: View {
    let dish: Dish
    var dinerPhoto: CrowdPhoto?

    @State private var progress: CGFloat = 0.5    // 0 diner photo … 1 menu photo
    @State private var dragStart: CGFloat?
    @State private var isDragging = false
    @State private var hasInteracted = false
    @State private var edgeHits = 0

    var body: some View {
        GeometryReader { geo in
            CompareReveal(progress: progress,
                          dish: dish,
                          dinerPhoto: dinerPhoto,
                          size: geo.size,
                          showHint: !hasInteracted)
                .gesture(knobDrag(width: geo.size.width), including: .all)
                .onTapGesture { flip() }
        }
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: edgeHits)
        .sensoryFeedback(.impact(weight: .light), trigger: isDragging) { _, began in began }
    }

    private func knobDrag(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if dragStart == nil {
                    // Claim only clearly-horizontal drags; let scroll have vertical.
                    guard abs(value.translation.width) >= abs(value.translation.height) else { return }
                    dragStart = progress
                    isDragging = true
                    hasInteracted = true
                }
                let raw = (dragStart ?? 0) + value.translation.width / width
                let previous = progress
                progress = min(max(raw, 0), 1)
                if (progress == 0 && previous > 0) || (progress == 1 && previous < 1) {
                    edgeHits += 1
                }
            }
            .onEnded { _ in
                guard dragStart != nil else { return }
                dragStart = nil
                isDragging = false
                // Rest where released; settle only when very close to an edge.
                if progress < 0.08 {
                    withAnimation(.spring(duration: 0.35, bounce: 0.15)) { progress = 0 }
                } else if progress > 0.92 {
                    withAnimation(.spring(duration: 0.35, bounce: 0.15)) { progress = 1 }
                }
            }
    }

    /// Tap flips to whichever side is hidden.
    private func flip() {
        hasInteracted = true
        withAnimation(.spring(duration: 0.55, bounce: 0.12)) {
            progress = progress < 0.5 ? 1 : 0
        }
    }
}

// MARK: - Animatable reveal

struct CompareReveal: View, Animatable {
    var progress: CGFloat
    let dish: Dish
    var dinerPhoto: CrowdPhoto?
    let size: CGSize
    let showHint: Bool

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    private var clamped: CGFloat { min(max(progress, 0), 1) }
    private var edge: CGFloat { clamped * size.width }

    var body: some View {
        ZStack {
            // Diner photo (right side, the base layer)
            Group {
                if let p = dinerPhoto {
                    DeliveredPhoto(imageName: p.imageName, style: p.style,
                                   rotation: p.rotation, zoom: p.zoom,
                                   anchor: p.anchor, exposure: p.exposure)
                        .transition(.scale(scale: 0.92).combined(with: .opacity))
                        .id("diner-\(p.id)")
                } else {
                    DeliveredPhoto(imageName: dish.imageName, style: .neutral)
                        .transition(.opacity)
                        .id("diner-default")
                }
            }

            // Menu photo, revealed from the leading edge
            StudioPhoto(imageName: dish.imageName)
                .frame(width: size.width, height: size.height)
                .clipped()
                .mask(alignment: .leading) {
                    Rectangle().frame(width: max(0, edge))
                }

            divider
        }
        .overlay(alignment: .topLeading) { labelPill("Menu photo", icon: "fork.knife").padding(10) }
        .overlay(alignment: .topTrailing) {
            labelPill(dinerLabel, icon: "camera.fill")
                .padding(10)
                .padding(.trailing, 36)   // clear of the sheet's close button
        }
        .overlay(alignment: .bottomTrailing) {
            if showHint { hintChip.padding(.trailing, 12).padding(.bottom, 10) }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .accessibilityLabel("\(dish.name). Compare the menu photo with diner delivery photos. Drag the handle or tap to flip.")
    }

    private var dinerLabel: String {
        if let p = dinerPhoto { "Diner photo · \(p.stamp)" }
        else { "Diner photo · \(dish.deliveredAt)" }
    }

    private func labelPill(_ text: String, icon: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 9, weight: .semibold))
            Text(text).font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(.black.opacity(0.6)))
    }

    // Zomato-style handle: white circle, red border, chevrons.
    private var divider: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 3)
                .shadow(color: .black.opacity(0.30), radius: 3)
            Circle()
                .fill(.white)
                .frame(width: 34, height: 34)
                .overlay(Circle().strokeBorder(ZTheme.red, lineWidth: 2))
                .overlay {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(ZTheme.red)
                }
                .shadow(color: .black.opacity(0.25), radius: 4, y: 1)
        }
        .position(x: max(12, min(size.width - 12, edge)), y: size.height / 2)
    }

    private var hintChip: some View {
        HStack(spacing: 5) {
            Image(systemName: "arrow.left.and.right")
                .font(.system(size: 10, weight: .bold))
            Text("Drag to compare")
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(.black.opacity(0.6)))
        .phaseAnimator([0, 1]) { content, phase in
            content.opacity(phase == 0 ? 0.65 : 1)
        } animation: { _ in .easeInOut(duration: 0.8) }
    }
}

#Preview("Reality viewer") {
    Color.black.sheet(isPresented: .constant(true)) {
        RealityViewer(dish: Dish.menu[0])
    }
}

#Preview("Early days") {
    Color.black.sheet(isPresented: .constant(true)) {
        RealityViewer(dish: Dish.menu[4])
    }
}
