//
//  PhotoGrade.swift
//  Zomato — "Reality mode" dish photos
//
//  Light grading so the same source photo can read as the restaurant's
//  menu shot or one of many diner uploads. No blur, minimal overlays —
//  these render in lists and grids and must stay cheap.
//

import SwiftUI

/// The restaurant's menu shot: clean and saturated.
struct StudioPhoto: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .saturation(1.08)
            .contrast(1.03)
    }
}

/// A diner's photo of the same dish. Style varies like real uploads do.
struct DeliveredPhoto: View {
    let imageName: String
    var style: PhotoStyle = .neutral
    var rotation: Double = 1.5
    var zoom: CGFloat = 1.18
    var anchor: UnitPoint = .center
    var exposure: Double = 0

    var body: some View {
        Color.clear
            .overlay {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(zoom, anchor: anchor)
                    .rotationEffect(.degrees(rotation))
                    .saturation(saturation)
                    .brightness(brightness + exposure)
                    .contrast(contrast)
            }
            .overlay {
                if style == .dim {
                    LinearGradient(colors: [.clear, .black.opacity(0.30)],
                                   startPoint: .center, endPoint: .bottom)
                }
            }
            .clipped()
    }

    private var saturation: Double {
        switch style {
        case .bright: 1.05
        case .neutral: 0.92
        case .dim: 0.72
        }
    }

    private var brightness: Double {
        switch style {
        case .bright: 0.03
        case .neutral: -0.03
        case .dim: -0.10
        }
    }

    private var contrast: Double {
        switch style {
        case .bright: 1.02
        case .neutral: 0.98
        case .dim: 0.94
        }
    }
}

/// A gallery tile: a diner photo with its delivery timestamp.
struct CrowdPhotoTile: View {
    let photo: CrowdPhoto
    var showsStamp = true

    var body: some View {
        DeliveredPhoto(imageName: photo.imageName,
                       style: photo.style,
                       rotation: photo.rotation,
                       zoom: photo.zoom,
                       anchor: photo.anchor,
                       exposure: photo.exposure)
            .drawingGroup()
            .overlay(alignment: .bottomTrailing) {
                if showsStamp {
                    Text(photo.stamp)
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(4)
                }
            }
    }
}
