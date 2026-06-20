//
//  DishData.swift
//  Zomato — "Reality mode" dish photos
//
//  Mock data: Itminaan Matka Biryani menu, diner-uploaded "as delivered"
//  photos, and home-feed restaurants. Photo accuracy is rated by diners.
//

import SwiftUI

// MARK: - Photo accuracy (Zomato rating-box language)

enum PhotoAccuracy {
    /// Zomato-style rating colors: green ≥ 4, amber 3–3.9, orange-red below.
    static func color(_ rating: Double) -> Color {
        switch rating {
        case 4.0...: ZTheme.ratingGreen
        case 3.0..<4.0: Color(red: 0.85, green: 0.60, blue: 0.10)
        default: Color(red: 0.83, green: 0.38, blue: 0.12)
        }
    }
}

// MARK: - Dish

struct Dish: Identifiable {
    let id: Int
    let name: String
    let strikePrice: Int?       // ₹858 struck through
    let price: Int              // "Get for ₹399"
    let blurb: String
    let imageName: String
    /// Diner-rated: how closely delivery matches the menu photo.
    /// nil = fewer than 10 photos — too early to score honestly.
    let photoAccuracy: Double?
    let orderCount: Int
    let photoCount: Int
    let deliveredAt: String
    let isSpicy: Bool
    let highlyReordered: Bool
    let couponNote: Bool        // "NOT ELIGIBLE FOR COUPONS"
    // Crowd consensus from delivery feedback
    let arrivesHot: Int
    let spillProof: Int
    let looksLikePhoto: Int

    var accuracyLabel: String? { photoAccuracy.map { String(format: "%.1f", $0) } }
    var accuracyColor: Color {
        photoAccuracy.map(PhotoAccuracy.color) ?? ZTheme.ink3
    }
    var orderCountLabel: String { orderCount.formatted(.number.grouping(.automatic)) }

    static let menu: [Dish] = [
        Dish(id: 0,
             name: "1 KG Paneer & Subz Supreme Matka Biryani + Dessert + Drink",
             strikePrice: 858, price: 399,
             blurb: "Combo contains Biryani, Gulab Jamun, Lemonade & 2 Raitas. [SERVES 2-3] Slow-cooked Biryani with succulent paneer & vegetables.",
             imageName: "menu_supreme",
             photoAccuracy: 2.9, orderCount: 1243, photoCount: 147, deliveredAt: "9:43 PM",
             isSpicy: false, highlyReordered: true, couponNote: true,
             arrivesHot: 81, spillProof: 94, looksLikePhoto: 58),
        Dish(id: 1,
             name: "1 KG Veg Nawabi Matka Biryani + FREE Dessert",
             strikePrice: 429, price: 299,
             blurb: "[SERVES 2 | Comes with 2 Raitas & 1 Dessert] Freshly chopped vegetables slow-cooked with nawabi spices.",
             imageName: "menu_nawabi",
             photoAccuracy: 4.2, orderCount: 987, photoCount: 112, deliveredAt: "10:12 PM",
             isSpicy: false, highlyReordered: false, couponNote: true,
             arrivesHot: 88, spillProof: 91, looksLikePhoto: 84),
        Dish(id: 2,
             name: "1 KG Veg & Paneer Overload Matka Biryani + FREE Dessert",
             strikePrice: 499, price: 379,
             blurb: "[SERVES 2 | Comes with 2 Raitas & 1 Dessert] Succulent pieces of paneer overloaded over dum biryani.",
             imageName: "menu_overload",
             photoAccuracy: 3.6, orderCount: 742, photoCount: 86, deliveredAt: "8:57 PM",
             isSpicy: true, highlyReordered: false, couponNote: true,
             arrivesHot: 76, spillProof: 89, looksLikePhoto: 71),
        Dish(id: 3,
             name: "1 KG Original Paneer Matka Biryani + FREE Dessert",
             strikePrice: 529, price: 399,
             blurb: "[SERVES 2 | Comes with 2 Raitas & 1 Dessert] The original slow-cooked paneer matka biryani recipe.",
             imageName: "menu_paneer",
             photoAccuracy: 2.8, orderCount: 1581, photoCount: 203, deliveredAt: "11:26 PM",
             isSpicy: false, highlyReordered: true, couponNote: false,
             arrivesHot: 69, spillProof: 92, looksLikePhoto: 54),
        Dish(id: 4,
             name: "Special Hyderabad Veg Biryani",
             strikePrice: nil, price: 299,
             blurb: "[Medium Spicy] Served with curry/gravy and raita.",
             imageName: "menu_hyderabad",
             photoAccuracy: nil, orderCount: 451, photoCount: 7, deliveredAt: "1:14 PM",
             isSpicy: true, highlyReordered: true, couponNote: false,
             arrivesHot: 0, spillProof: 0, looksLikePhoto: 0),
    ]
}

// MARK: - Diner photos

enum PhotoStyle {
    case bright, neutral, dim
}

/// Per-photo variation so recycled assets read as distinct diner uploads.
struct CrowdPhoto: Identifiable {
    let id: Int
    let imageName: String
    let reviewer: String
    let timeAgo: String
    let stamp: String          // delivery timestamp
    let helpful: Int
    let caption: String?
    let stars: Int             // this diner's accuracy vote, 1...5
    let style: PhotoStyle
    let rotation: Double       // degrees
    let zoom: CGFloat
    let anchor: UnitPoint
    let exposure: Double

    /// Deterministic pseudo-random diner photos for a dish.
    /// Style mix ~40% bright / 35% neutral / 25% dim — real uploads vary.
    static func photos(for dish: Dish, count: Int = 24) -> [CrowdPhoto] {
        let names = ["Riya S.", "Aman V.", "Priyanka", "Rohit K.", "Sneha M.", "Arjun",
                     "Divya T.", "Kunal", "Ishita B.", "Vikram", "Megha J.", "Sahil R."]
        let agos  = ["2 days ago", "5 days ago", "1 week ago", "2 weeks ago",
                     "3 weeks ago", "1 month ago", "2 months ago"]
        let stamps = ["9:43 PM", "1:14 PM", "8:57 PM", "12:40 PM", "9:05 PM", "7:31 PM", "2:22 PM"]
        let captions: [String?] = ["Looked just like the picture", nil,
                                   "Portion was smaller than the photo", nil, nil,
                                   "Arrived warm, garnish was missing", "Pretty close to the menu photo",
                                   nil, "Good quantity, packaging could be better", nil,
                                   "Came in a regular container, taste was great", nil]
        return (0..<count).map { i in
            let h = (dish.id * 31 + i * 17) % 97
            let style: PhotoStyle = switch h % 20 {
            case 0..<8: .bright
            case 8..<15: .neutral
            default: .dim
            }
            let stars: Int = switch style {
            case .bright: 4 + (h % 2)
            case .neutral: 3 + (h % 2)
            case .dim: 2 + (h % 2)
            }
            return CrowdPhoto(
                id: i,
                imageName: dish.imageName,
                reviewer: names[(dish.id + i) % names.count],
                timeAgo: agos[(dish.id * 3 + i) % agos.count],
                stamp: stamps[(dish.id + i * 5) % stamps.count],
                helpful: max(0, 47 - i * 2 + h % 9),
                caption: captions[(dish.id * 7 + i) % captions.count],
                stars: stars,
                style: style,
                rotation: Double((h % 7)) - 3.0,
                zoom: 1.18 + CGFloat(h % 5) * 0.10,
                anchor: [UnitPoint.center, .topLeading, .top, .trailing, .bottomLeading,
                         .leading, .bottom][(h + i) % 7],
                exposure: -0.02 - Double(h % 4) * 0.015
            )
        }
    }
}

// MARK: - Home feed restaurants

struct HomeRestaurant: Identifiable {
    let id: Int
    let name: String
    let rating: Double
    let imageName: String
    let offer: String?
    let photoAccuracy: Double
    let photoCount: Int

    static let feed: [HomeRestaurant] = [
        HomeRestaurant(id: 0, name: "Itminaan Matka Biryani", rating: 4.4, imageName: "menu_supreme",
                       offer: "50% OFF up to ₹100", photoAccuracy: 3.1, photoCount: 586),
        HomeRestaurant(id: 1, name: "Hyderabad Biryaani House", rating: 3.8, imageName: "menu_hyderabad",
                       offer: nil, photoAccuracy: 4.5, photoCount: 212),
        HomeRestaurant(id: 2, name: "Queens Courts", rating: 4.6, imageName: "menu_nawabi",
                       offer: "₹40 OFF above ₹399", photoAccuracy: 4.1, photoCount: 167),
        HomeRestaurant(id: 3, name: "Jain Sons Fast Food", rating: 4.6, imageName: "menu_overload",
                       offer: "50% OFF select items", photoAccuracy: 3.7, photoCount: 340),
    ]
}
