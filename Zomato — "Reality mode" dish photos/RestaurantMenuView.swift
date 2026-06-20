//
//  RestaurantMenuView.swift
//  Zomato — "Reality mode" dish photos
//
//  Itminaan Matka Biryani — Slow Cooked. Faithful menu rows; every dish
//  photo defaults to the as-delivered shot. Tap a photo for the reality
//  check.
//

import SwiftUI

struct RestaurantMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var realityMode = true
    @State private var presentedDish: Dish?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    restaurantHeader
                    deliveryBanner
                    offersRow
                    Rectangle().fill(ZTheme.canvas).frame(height: 8)
                    filterChips
                    sectionHeader("Best in Biryani")
                    menuRows
                    footer
                }
            }
            .scrollIndicators(.hidden)
            .background(.white)

            menuFab
                .padding(.trailing, 18)
                .padding(.bottom, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .sheet(item: $presentedDish) { dish in
            RealityViewer(dish: dish)
        }
    }

    // MARK: Top bar

    private var topBar: some View {
        HStack(spacing: 10) {
            circleButton("arrow.left") { dismiss() }
            Spacer()
            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass").font(.system(size: 13, weight: .semibold))
                    Text("Search").font(.system(size: 14.5, weight: .medium))
                }
                .foregroundStyle(ZTheme.ink)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Capsule().fill(.white))
                .overlay(Capsule().strokeBorder(ZTheme.hairline, lineWidth: 1.2))
            }
            .buttonStyle(.plain)
            circleButton("person.badge.plus") {}
            circleButton("ellipsis") {}
        }
        .padding(.horizontal, 14)
        .padding(.top, 6)
        .padding(.bottom, 10)
    }

    private func circleButton(_ name: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ZTheme.ink)
                .frame(width: 44, height: 44)
                .background(Circle().fill(.white))
                .overlay(Circle().strokeBorder(ZTheme.hairline, lineWidth: 1.2))
        }
        .buttonStyle(.plain)
    }

    // MARK: Header

    private var restaurantHeader: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .top) {
                Text("Itminaan Matka Biryani - Slow Cooked")
                    .font(ZTheme.heading(27, .heavy))
                    .foregroundStyle(ZTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Image(systemName: "info.circle")
                    .font(.system(size: 15))
                    .foregroundStyle(ZTheme.ink3)
                    .padding(.top, 8)
                Spacer(minLength: 8)
                VStack(spacing: 3) {
                    HStack(spacing: 3) {
                        Text("4.4").font(.system(size: 15, weight: .heavy))
                        Image(systemName: "star.fill").font(.system(size: 10, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 9).fill(ZTheme.ratingGreen))
                    Text("For you")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(ZTheme.ink3)
                }
            }

            HStack(spacing: 5) {
                Image(systemName: "mappin.circle").foregroundStyle(ZTheme.ink2)
                Text("1.4 km · Brookefield")
                Image(systemName: "chevron.down").font(.system(size: 10, weight: .bold))
                    .foregroundStyle(ZTheme.ink3)
            }
            .font(.system(size: 14.5, weight: .medium))
            .foregroundStyle(ZTheme.ink2)

            HStack(spacing: 5) {
                Image(systemName: "bolt.fill").foregroundStyle(ZTheme.ratingGreen)
                Text("25–30 mins").foregroundStyle(ZTheme.ratingGreen).fontWeight(.semibold)
                Text("· Schedule for later").foregroundStyle(ZTheme.ink2)
                Image(systemName: "chevron.down").font(.system(size: 10, weight: .bold))
                    .foregroundStyle(ZTheme.ink3)
            }
            .font(.system(size: 14.5, weight: .medium))

            HStack(spacing: 6) {
                Image(systemName: "hands.clap.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.72, green: 0.45, blue: 0.20))
                Text("2 dishes loved by Samkith Bhaiya")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(ZTheme.ink2)
                Image(systemName: "chevron.down").font(.system(size: 10, weight: .bold))
                    .foregroundStyle(ZTheme.ink3)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(ZTheme.chipBG))
        }
        .padding(.horizontal, 16)
    }

    private var deliveryBanner: some View {
        HStack {
            Text("Delivery is managed by the restaurant")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(red: 0.45, green: 0.35, blue: 0.08))
            Spacer()
            Image(systemName: "scooter")
                .font(.system(size: 17))
                .foregroundStyle(Color(red: 0.45, green: 0.35, blue: 0.08))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(red: 1.0, green: 0.97, blue: 0.86))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color(red: 0.92, green: 0.82, blue: 0.45), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 14)
    }

    private var offersRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "seal.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 0.25, green: 0.45, blue: 0.95))
                .overlay {
                    Text("%").font(.system(size: 7, weight: .heavy)).foregroundStyle(.white)
                }
            Text("50% OFF up to ₹100 above ₹159")
                .font(.system(size: 14.5, weight: .semibold))
                .foregroundStyle(ZTheme.ink)
            Spacer()
            Text("7 offers")
                .font(.system(size: 13.5))
                .foregroundStyle(ZTheme.ink3)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(ZTheme.ink3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: Filter chips

    private var filterChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                chip(active: true) {
                    HStack(spacing: 5) {
                        Image(systemName: "slider.horizontal.3").font(.system(size: 12))
                        Text("Filters (1)")
                        Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold))
                    }
                }
                chip(active: true) {
                    HStack(spacing: 5) {
                        Image(systemName: "eye.slash").font(.system(size: 11))
                        Text("Hide non-veg")
                        Image(systemName: "xmark").font(.system(size: 9, weight: .bold))
                    }
                }
                realityChip
                chip {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(ZTheme.ratingGreen)
                        Text("Highly reordered")
                    }
                }
                chip {
                    HStack(spacing: 5) {
                        ChiliMark(size: 12)
                        Text("Spicy")
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, 12)
    }

    private func chip<Content: View>(active: Bool = false,
                                     @ViewBuilder _ content: () -> Content) -> some View {
        content()
            .font(.system(size: 13.5, weight: .medium))
            .foregroundStyle(active ? ZTheme.ratingGreen : ZTheme.ink)
            .padding(.horizontal, 13)
            .frame(height: 38)
            .background(
                Capsule().fill(active ? Color(red: 0.94, green: 0.98, blue: 0.95) : .white)
            )
            .overlay(
                Capsule().strokeBorder(active ? ZTheme.ratingGreen.opacity(0.5) : ZTheme.hairline,
                                       lineWidth: 1.2)
            )
    }

    private var realityChip: some View {
        Button {
            withAnimation(.spring(duration: 0.35, bounce: 0.3)) { realityMode.toggle() }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: realityMode ? "eye.fill" : "eye.slash")
                    .font(.system(size: 11, weight: .semibold))
                Text("Reality mode")
            }
            .font(.system(size: 13.5, weight: .semibold))
            .foregroundStyle(realityMode ? .white : ZTheme.ink)
            .padding(.horizontal, 13)
            .frame(height: 38)
            .background(Capsule().fill(realityMode ? ZTheme.red : .white))
            .overlay(Capsule().strokeBorder(realityMode ? ZTheme.redDeep : ZTheme.hairline,
                                            lineWidth: 1.2))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .medium), trigger: realityMode)
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(ZTheme.heading(19, .bold))
                .foregroundStyle(ZTheme.ink)
            Spacer()
            Image(systemName: "chevron.up")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ZTheme.ink2)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 4)
    }

    // MARK: Menu rows

    private var menuRows: some View {
        VStack(spacing: 0) {
            ForEach(Dish.menu) { dish in
                MenuRow(dish: dish, realityMode: realityMode, showsHint: dish.id == 0) {
                    presentedDish = dish
                }
                if dish.id != Dish.menu.last?.id {
                    DashedDivider().padding(.horizontal, 16).padding(.vertical, 14)
                }
            }
        }
        .padding(.top, 10)
        .scrollTargetLayout()
    }

    private var footer: some View {
        Text("Reality photos are uploaded by diners after delivery.")
            .font(.system(size: 11.5))
            .foregroundStyle(ZTheme.ink3)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
            .padding(.top, 30)
            .padding(.bottom, 110)
    }

    private var menuFab: some View {
        Button {} label: {
            HStack(spacing: 7) {
                Image(systemName: "fork.knife").font(.system(size: 13, weight: .semibold))
                Text("Menu").font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 48)
            .glassEffect(.regular.tint(.black.opacity(0.85)).interactive(), in: .capsule)
            .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Menu row (text left, photo right — the real app's anatomy)

struct MenuRow: View {
    let dish: Dish
    let realityMode: Bool
    var showsHint = false
    let openViewer: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 6) {
                    VegMark(size: 16)
                    if dish.isSpicy { ChiliMark(size: 14) }
                }
                Text(dish.name)
                    .font(.system(size: 16.5, weight: .bold))
                    .foregroundStyle(ZTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)

                if dish.highlyReordered {
                    HStack(spacing: 6) {
                        Capsule().fill(ZTheme.ratingGreen)
                            .frame(width: 30, height: 10)
                            .overlay(alignment: .trailing) {
                                Capsule().fill(Color(red: 0.85, green: 0.90, blue: 0.86))
                                    .frame(width: 8, height: 10)
                            }
                        Text("Highly reordered")
                            .font(.system(size: 12.5, weight: .medium))
                            .foregroundStyle(ZTheme.ink2)
                    }
                }

                if let strike = dish.strikePrice {
                    Text("₹\(strike)")
                        .font(.system(size: 13.5, weight: .medium))
                        .strikethrough()
                        .foregroundStyle(ZTheme.ink3)
                    Text("Get for ₹\(dish.price)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(red: 0.16, green: 0.38, blue: 0.85))
                } else {
                    Text("₹\(dish.price)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(ZTheme.ink)
                }

                Text("\(Text(dish.blurb.prefix(64) + "... ").foregroundStyle(ZTheme.ink3))\(Text("more").foregroundStyle(ZTheme.ink2).bold())")
                    .font(.system(size: 13))
                    .lineLimit(2)

                if dish.couponNote {
                    Text("NOT ELIGIBLE FOR COUPONS")
                        .font(.system(size: 10.5, weight: .semibold))
                        .tracking(0.6)
                        .foregroundStyle(ZTheme.ink3)
                }

                // Photo accuracy: rated by diners who received the dish
                Button(action: openViewer) {
                    HStack(spacing: 4) {
                        Image(systemName: "camera.fill").font(.system(size: 9))
                        Text("\(dish.photoCount) photos")
                            .font(.system(size: 11, weight: .semibold))
                        if let label = dish.accuracyLabel {
                            Text("· \(label)")
                                .font(.system(size: 11, weight: .bold))
                            Image(systemName: "star.fill").font(.system(size: 7, weight: .bold))
                        } else {
                            Text("· Early days")
                                .font(.system(size: 11, weight: .semibold))
                        }
                    }
                    .foregroundStyle(dish.accuracyColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4.5)
                    .background(Capsule().fill(dish.accuracyColor.opacity(0.10)))
                }
                .buttonStyle(.plain)
                .padding(.top, 1)

                HStack(spacing: 10) {
                    RoundIconButton(systemName: "bookmark")
                    RoundIconButton(systemName: "arrowshape.turn.up.right")
                }
                .padding(.top, 3)
            }
            Spacer(minLength: 0)
            dishPhoto
        }
        .padding(.horizontal, 16)
    }

    private var dishPhoto: some View {
        VStack(spacing: 4) {
            Button(action: openViewer) {
                ZStack {
                    if realityMode {
                        DeliveredPhoto(imageName: dish.imageName)
                    } else {
                        StudioPhoto(imageName: dish.imageName)
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if realityMode {
                        HStack(spacing: 3) {
                            Image(systemName: "camera.fill").font(.system(size: 7, weight: .bold))
                            Text("Diner photo")
                                .font(.system(size: 9, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.black.opacity(0.6)))
                        .padding(6)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    if showsHint {
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white, .black.opacity(0.45))
                            .padding(6)
                            .phaseAnimator([0, 1]) { content, phase in
                                content.opacity(phase == 0 ? 0.5 : 1)
                            } animation: { _ in .easeInOut(duration: 0.8) }
                    }
                }
                .animation(.smooth(duration: 0.3), value: realityMode)
            }
            .buttonStyle(.plain)

            Button(action: openViewer) {
                HStack(alignment: .top, spacing: 2) {
                    Text("ADD").font(.system(size: 15, weight: .heavy))
                    Text("+").font(.system(size: 11, weight: .heavy)).offset(y: -2)
                }
                .foregroundStyle(ZTheme.ratingGreen)
                .frame(width: 110, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(Color(red: 0.95, green: 0.99, blue: 0.96))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .strokeBorder(ZTheme.ratingGreen.opacity(0.5), lineWidth: 1.2)
                )
                .shadow(color: .black.opacity(0.08), radius: 5, y: 2)
            }
            .buttonStyle(.plain)
            .offset(y: -22)
            .padding(.bottom, -22)

            Text("customisable")
                .font(.system(size: 11.5))
                .foregroundStyle(ZTheme.ink3)
        }
    }
}

struct DashedDivider: View {
    var body: some View {
        Line()
            .stroke(ZTheme.hairline, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .frame(height: 1)
    }

    private struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: 0, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.width, y: rect.midY))
            return p
        }
    }
}

#Preview("Restaurant") {
    NavigationStack { RestaurantMenuView() }
}
