//
//  CrowdGalleryView.swift
//  Zomato — "Reality mode" dish photos
//
//  Every "as delivered" photo diners have posted for a dish — the
//  Amazon-reviews treatment for biryani. Dark gallery grid with count
//  tabs, plus a single-photo viewer with helpful votes.
//

import SwiftUI

struct CrowdGalleryView: View {
    let dish: Dish
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab = 0
    @State private var selectedPhoto: CrowdPhoto?

    private var photos: [CrowdPhoto] { CrowdPhoto.photos(for: dish, count: min(27, dish.photoCount)) }

    private var tabs: [(String, Int)] {
        let topRated = Int(Double(dish.photoCount) * 0.4)
        let withNote = Int(Double(dish.photoCount) * 0.3)
        return [("All", dish.photoCount), ("Recent", min(24, dish.photoCount)),
                ("Top rated", topRated), ("With note", withNote)]
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            tabBar
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 3),
                          spacing: 3) {
                    ForEach(visiblePhotos) { photo in
                        Button { selectedPhoto = photo } label: {
                            CrowdPhotoTile(photo: photo)
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 3)
                .padding(.top, 10)

                Text("Photos are uploaded by diners after delivery.")
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        .preferredColorScheme(.dark)
        .sheet(item: $selectedPhoto) { photo in
            CrowdPhotoDetail(dish: dish, photo: photo, all: photos)
        }
    }

    private var visiblePhotos: [CrowdPhoto] {
        switch selectedTab {
        case 1:  Array(photos.prefix(12))                         // recent
        case 2:  photos.filter { $0.stars >= 4 }                  // top rated
        case 3:  photos.filter { $0.caption != nil }              // with note
        default: photos
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 2) {
                Text(dish.name)
                    .font(ZTheme.heading(15, .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text("Reality check · \(dish.orderCountLabel) orders")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.55))
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var tabBar: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { i, tab in
                    Button {
                        withAnimation(.spring(duration: 0.3)) { selectedTab = i }
                    } label: {
                        Text("\(tab.0) (\(tab.1))")
                            .font(.system(size: 13.5, weight: .semibold))
                            .foregroundStyle(selectedTab == i ? .black : .white)
                            .padding(.horizontal, 14)
                            .frame(height: 36)
                            .background(
                                Capsule().fill(selectedTab == i ? .white : Color(white: 0.16))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, 4)
        .sensoryFeedback(.selection, trigger: selectedTab)
    }
}

// MARK: - Single photo viewer (Posted by · Helpful · thumbnails)

struct CrowdPhotoDetail: View {
    let dish: Dish
    @State var photo: CrowdPhoto
    let all: [CrowdPhoto]
    @Environment(\.dismiss) private var dismiss

    @State private var helpfulVotes: Set<Int> = []

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                Spacer()
                Text("As delivered")
                    .font(ZTheme.heading(15, .bold))
                    .foregroundStyle(.white)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)

            Spacer()

            CrowdPhotoTile(photo: photo, showsStamp: false)
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    Text(photo.stamp)
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(8)
                }
                .padding(.horizontal, 14)
                .id(photo.id)
                .transition(.opacity)

            VStack(spacing: 6) {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < photo.stars ? "star.fill" : "star")
                            .font(.system(size: 11))
                            .foregroundStyle(i < photo.stars
                                             ? PhotoAccuracy.color(Double(photo.stars))
                                             : .white.opacity(0.3))
                    }
                    Text("photo accuracy")
                        .font(.system(size: 11.5))
                        .foregroundStyle(.white.opacity(0.55))
                        .padding(.leading, 4)
                }
                if let caption = photo.caption {
                    Text("\u{201C}\(caption)\u{201D}")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                }
                Text("Posted by \(photo.reviewer) · \(photo.timeAgo)")
                    .font(.system(size: 12.5))
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(.top, 14)

            actionRow
                .padding(.top, 14)

            Spacer()

            thumbnailStrip
        }
        .background(Color(red: 0.05, green: 0.05, blue: 0.06))
        .preferredColorScheme(.dark)
    }

    private var actionRow: some View {
        HStack(spacing: 26) {
            let voted = helpfulVotes.contains(photo.id)
            Button {
                if voted { helpfulVotes.remove(photo.id) } else { helpfulVotes.insert(photo.id) }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: voted ? "hand.thumbsup.fill" : "hand.thumbsup")
                    Text("Helpful (\(photo.helpful + (voted ? 1 : 0)))")
                        .monospacedDigit()
                }
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.impact(weight: .light), trigger: voted)

            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                    Text("Comment")
                }
            }
            .buttonStyle(.plain)

            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrowshape.turn.up.right")
                    Text("Share")
                }
            }
            .buttonStyle(.plain)
        }
        .font(.system(size: 13.5, weight: .semibold))
        .foregroundStyle(.white.opacity(0.85))
    }

    private var thumbnailStrip: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 6) {
                ForEach(all.prefix(14)) { p in
                    Button {
                        withAnimation(.smooth(duration: 0.2)) { photo = p }
                    } label: {
                        CrowdPhotoTile(photo: p, showsStamp: false)
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.white, lineWidth: p.id == photo.id ? 2 : 0)
                            )
                            .opacity(p.id == photo.id ? 1 : 0.55)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, 18)
        .sensoryFeedback(.selection, trigger: photo.id)
    }
}

#Preview("Gallery") {
    CrowdGalleryView(dish: Dish.menu[0])
}
