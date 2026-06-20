//
//  HomeFeedView.swift
//  Zomato — "Reality mode" dish photos
//
//  The delivery home feed: gold banner, category rail, recommended grid.
//  Chronic offenders wear their gap scores on the feed itself.
//

import SwiftUI

struct HomeFeedView: View {
    @State private var vegMode = true
    @State private var selectedCategory = 0
    @State private var selectedTab = 0

    private let categories = ["All", "Paratha", "North Indian", "Paneer", "Biryani"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    locationHeader
                    searchRow
                    goldBanner
                    categoryRail
                    filterRow
                    recommendedSection
                }
            }
            .scrollIndicators(.hidden)
            tabBar
        }
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: Location header

    private var locationHeader: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 15, weight: .bold))
                    Text("Home")
                        .font(ZTheme.heading(20, .heavy))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundStyle(ZTheme.ink)
                Text("212 Barya Vihar Civil Lines, Civ…")
                    .font(.system(size: 13))
                    .foregroundStyle(ZTheme.ink2)
                    .lineLimit(1)
            }
            Spacer()
            HStack(spacing: 4) {
                Text("GOLD")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(Color(red: 0.55, green: 0.42, blue: 0.12))
                Text("₹30")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(red: 0.55, green: 0.42, blue: 0.12))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color(red: 0.99, green: 0.95, blue: 0.82)))
            .overlay(Capsule().strokeBorder(Color(red: 0.85, green: 0.72, blue: 0.40), lineWidth: 1))

            Image(systemName: "wallet.bifold")
                .font(.system(size: 15))
                .foregroundStyle(ZTheme.ink2)
                .frame(width: 38, height: 38)
                .background(Circle().fill(ZTheme.chipBG))

            Text("A")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(red: 0.25, green: 0.35, blue: 0.75))
                .frame(width: 38, height: 38)
                .background(Circle().fill(Color(red: 0.80, green: 0.86, blue: 0.99)))
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
    }

    // MARK: Search

    private var searchRow: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(ZTheme.red)
                Text("Search \u{201C}biryani\u{201D}")
                    .font(.system(size: 15.5))
                    .foregroundStyle(ZTheme.ink3)
                Spacer()
                Rectangle().fill(ZTheme.hairline).frame(width: 1, height: 22)
                Image(systemName: "mic.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(ZTheme.red)
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(ZTheme.hairline, lineWidth: 1.2))

            VStack(spacing: 3) {
                Text("VEG\nMODE")
                    .font(.system(size: 9, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(ZTheme.ink)
                Button {
                    withAnimation(.spring(duration: 0.3)) { vegMode.toggle() }
                } label: {
                    Capsule()
                        .fill(vegMode ? ZTheme.ratingGreen : Color(white: 0.8))
                        .frame(width: 38, height: 21)
                        .overlay(alignment: vegMode ? .trailing : .leading) {
                            Circle().fill(.white)
                                .frame(width: 17, height: 17)
                                .padding(2)
                        }
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.impact(weight: .light), trigger: vegMode)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    // MARK: Gold banner

    private var goldBanner: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(LinearGradient(colors: [Color(red: 0.95, green: 0.85, blue: 0.55),
                                              Color(red: 0.88, green: 0.72, blue: 0.38),
                                              Color(red: 0.93, green: 0.82, blue: 0.52)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))

            VStack(alignment: .leading, spacing: 10) {
                Text("Enjoy free delivery\nabove \(Text("₹199").strikethrough()) ₹99")
                    .font(ZTheme.heading(24, .heavy))
                    .foregroundStyle(Color(red: 0.42, green: 0.30, blue: 0.05))

                Text("Get GOLD at ₹30 for 3 months")
                    .font(.system(size: 14.5, weight: .semibold))
                    .foregroundStyle(Color(red: 0.45, green: 0.33, blue: 0.08))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(.white.opacity(0.35)))

                Button {} label: {
                    HStack(spacing: 6) {
                        Text("Renew now").font(.system(size: 14.5, weight: .bold))
                        Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Capsule().fill(.black))
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
            .padding(18)
        }
        .frame(height: 190)
        .overlay(alignment: .trailing) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(red: 0.80, green: 0.62, blue: 0.25),
                                                  Color(red: 0.65, green: 0.48, blue: 0.15)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 110, height: 110)
                Image(systemName: "crown.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color(red: 0.97, green: 0.92, blue: 0.75))
            }
            .padding(.trailing, 18)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    // MARK: Category rail

    private var categoryRail: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 18) {
                VStack(spacing: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.93, green: 0.90, blue: 0.83))
                            .frame(width: 64, height: 58)
                        VStack(spacing: 0) {
                            Text("MEALS UNDER")
                                .font(.system(size: 6.5, weight: .heavy))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5).padding(.vertical, 2)
                                .background(Color(red: 0.75, green: 0.15, blue: 0.15))
                            Text("₹250")
                                .font(ZTheme.heading(17, .heavy))
                                .foregroundStyle(Color(red: 0.20, green: 0.30, blue: 0.70))
                        }
                    }
                    Text("Explore")
                        .font(.system(size: 11.5, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 9).padding(.vertical, 3)
                        .background(Capsule().fill(Color(red: 0.25, green: 0.45, blue: 0.85)))
                        .offset(y: -8)
                }

                ForEach(Array(categories.enumerated()), id: \.offset) { i, cat in
                    Button {
                        withAnimation(.spring(duration: 0.3)) { selectedCategory = i }
                    } label: {
                        VStack(spacing: 6) {
                            if i == 0 {
                                StudioPhoto(imageName: "menu_supreme")
                                    .frame(width: 62, height: 62)
                                    .clipShape(Circle())
                            } else {
                                StudioPhoto(imageName: ["menu_nawabi", "menu_overload",
                                                        "menu_paneer", "menu_hyderabad"][(i - 1) % 4])
                                    .frame(width: 62, height: 62)
                                    .clipShape(Circle())
                            }
                            Text(cat)
                                .font(.system(size: 13.5,
                                              weight: selectedCategory == i ? .bold : .medium))
                                .foregroundStyle(selectedCategory == i ? ZTheme.ink : ZTheme.ink2)
                            Capsule()
                                .fill(selectedCategory == i ? ZTheme.ratingGreen : .clear)
                                .frame(width: 46, height: 3)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 18)
        .sensoryFeedback(.selection, trigger: selectedCategory)
    }

    // MARK: Filters

    private var filterRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                homeChip {
                    HStack(spacing: 5) {
                        Image(systemName: "slider.horizontal.3").font(.system(size: 12))
                        Text("Filters")
                        Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold))
                    }
                }
                homeChip {
                    HStack(spacing: 5) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(ZTheme.ratingGreen)
                        Text("Near & Fast")
                    }
                }
                homeChip { Text("New to you") }
                homeChip { Text("Great offers") }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }

    private func homeChip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .font(.system(size: 13.5, weight: .medium))
            .foregroundStyle(ZTheme.ink)
            .padding(.horizontal, 13)
            .frame(height: 38)
            .background(Capsule().fill(.white))
            .overlay(Capsule().strokeBorder(ZTheme.hairline, lineWidth: 1.2))
    }

    // MARK: Recommended grid

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECOMMENDED FOR YOU")
                .font(.system(size: 13, weight: .semibold))
                .tracking(2.5)
                .foregroundStyle(ZTheme.ink2)
                .padding(.horizontal, 16)
                .padding(.top, 18)

            LazyVStack(spacing: 22) {
                ForEach(HomeRestaurant.feed) { restaurant in
                    NavigationLink {
                        RestaurantMenuView()
                    } label: {
                        RestaurantCard(restaurant: restaurant)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    // MARK: Tab bar

    private var tabBar: some View {
        HStack {
            tabItem(0, icon: "scooter", label: "Delivery")
            tabItem(1, icon: "tag", label: "Under ₹250")
            tabItem(2, icon: "bag", label: "History")
        }
        .padding(.top, 8)
        .padding(.bottom, 2)
        .background(.white)
        .overlay(alignment: .top) { Rectangle().fill(ZTheme.hairline).frame(height: 1) }
        .sensoryFeedback(.selection, trigger: selectedTab)
    }

    private func tabItem(_ index: Int, icon: String, label: String) -> some View {
        Button { selectedTab = index } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: selectedTab == index ? .semibold : .regular))
                Text(label)
                    .font(.system(size: 12.5, weight: selectedTab == index ? .bold : .medium))
            }
            .foregroundStyle(selectedTab == index ? ZTheme.ratingGreen : ZTheme.ink3)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Restaurant card

struct RestaurantCard: View {
    let restaurant: HomeRestaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            StudioPhoto(imageName: restaurant.imageName)
                .frame(height: 190)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if let offer = restaurant.offer {
                        Text(offer)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 7).fill(.black.opacity(0.6)))
                            .padding(8)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    HStack(spacing: 3) {
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.system(size: 12.5, weight: .heavy))
                        Image(systemName: "star.fill").font(.system(size: 9, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(ZTheme.ratingGreen))
                    .padding(8)
                }

            Text(restaurant.name)
                .font(ZTheme.heading(18, .bold))
                .foregroundStyle(ZTheme.ink)
                .lineLimit(1)

            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(ZTheme.ratingGreen)
                    Text("Near & Fast")
                        .font(.system(size: 13.5, weight: .semibold))
                        .foregroundStyle(ZTheme.ratingGreen)
                }
                HStack(spacing: 4) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 10))
                    Text("Photo accuracy \(String(format: "%.1f", restaurant.photoAccuracy))★")
                        .font(.system(size: 12.5, weight: .medium))
                }
                .foregroundStyle(ZTheme.ink3)
            }
        }
    }
}

#Preview("Home") {
    NavigationStack { HomeFeedView() }
}
