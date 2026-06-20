//
//  ZomatoTheme.swift
//  Zomato — "Reality mode" dish photos
//
//  Zomato visual language: colors, type, small reusable marks.
//

import SwiftUI

enum ZTheme {
    static let red        = Color(red: 0.886, green: 0.216, blue: 0.267)   // #E23744
    static let redDeep    = Color(red: 0.765, green: 0.157, blue: 0.208)
    static let vegGreen   = Color(red: 0.180, green: 0.580, blue: 0.267)   // #2E9444
    static let ratingGreen = Color(red: 0.145, green: 0.494, blue: 0.231)  // #257E3B
    static let ink        = Color(red: 0.110, green: 0.110, blue: 0.118)
    static let ink2       = Color(red: 0.310, green: 0.310, blue: 0.330)
    static let ink3       = Color(red: 0.510, green: 0.510, blue: 0.530)
    static let hairline   = Color(red: 0.910, green: 0.910, blue: 0.918)
    static let canvas     = Color(red: 0.965, green: 0.961, blue: 0.969)   // screen bg
    static let chipBG     = Color(red: 0.972, green: 0.972, blue: 0.976)
    static let gold       = Color(red: 0.788, green: 0.620, blue: 0.235)
    static let amber      = Color(red: 0.910, green: 0.640, blue: 0.180)

    static func heading(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

/// The green square + dot veg mark.
struct VegMark: View {
    var size: CGFloat = 16
    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.22)
            .strokeBorder(ZTheme.vegGreen, lineWidth: size * 0.10)
            .frame(width: size, height: size)
            .overlay(Circle().fill(ZTheme.vegGreen).frame(width: size * 0.45, height: size * 0.45))
            .accessibilityLabel("Pure veg")
    }
}

/// A tiny drawn chili (no emoji-as-icon).
struct ChiliMark: View {
    var size: CGFloat = 14
    var body: some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(colors: [Color(red: 0.85, green: 0.16, blue: 0.10),
                                              Color(red: 0.62, green: 0.07, blue: 0.05)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(width: size * 0.42, height: size)
            Capsule()
                .fill(Color(red: 0.28, green: 0.52, blue: 0.20))
                .frame(width: size * 0.18, height: size * 0.34)
                .offset(y: -size * 0.52)
        }
        .rotationEffect(.degrees(18))
        .accessibilityLabel("Spicy")
    }
}

/// Circular outline icon button (bookmark / share row).
struct RoundIconButton: View {
    let systemName: String
    var body: some View {
        Button {} label: {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(ZTheme.ink2)
                .frame(width: 38, height: 38)
                .background(Circle().strokeBorder(ZTheme.hairline, lineWidth: 1.2))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
