//
//  ScreenCalipers.swift
//  Cross-device sizing helpers, including iPad compatibility scaling.
//

import UIKit

enum ScreenCalipers {

    static var anchorSize: CGSize {
        UIScreen.main.bounds.size
    }

    static var safeInsets: UIEdgeInsets {
        if let stage = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let pane = stage.windows.first {
            return pane.safeAreaInsets
        }
        return .zero
    }

    static var compactSide: CGFloat {
        let size = anchorSize
        return min(size.width, size.height)
    }

    static var stretchedSide: CGFloat {
        let size = anchorSize
        return max(size.width, size.height)
    }

    static var slate: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// Scaling factor anchored to a 390pt iPhone canvas.
    static func swatch(_ value: CGFloat, anchor: CGFloat = 390) -> CGFloat {
        let raw = compactSide / anchor
        let curbed = min(max(raw, 0.85), slate ? 1.45 : 1.18)
        return value * curbed
    }

    /// Spacing tier scaled by device class.
    static func gutter(_ tier: Int) -> CGFloat {
        let base: CGFloat = slate ? 12 : 8
        return base * CGFloat(tier)
    }

    static func cornerSheen(_ tier: CGFloat = 18) -> CGFloat {
        swatch(tier)
    }

    static func glyphSize(_ pt: CGFloat) -> CGFloat {
        swatch(pt)
    }
}
