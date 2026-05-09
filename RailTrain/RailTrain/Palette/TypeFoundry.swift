//
//  TypeFoundry.swift
//  Font helpers tuned for the rail HUD.
//

import UIKit

enum TypeFoundry {

    static func display(_ size: CGFloat, weight: UIFont.Weight = .heavy) -> UIFont {
        let scaled = ScreenCalipers.glyphSize(size)
        if let monospaced = UIFont(name: "AvenirNext-Heavy", size: scaled), weight == .heavy {
            return monospaced
        }
        return UIFont.systemFont(ofSize: scaled, weight: weight)
    }

    static func headline(_ size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: ScreenCalipers.glyphSize(size), weight: .bold)
    }

    static func body(_ size: CGFloat, weight: UIFont.Weight = .medium) -> UIFont {
        UIFont.systemFont(ofSize: ScreenCalipers.glyphSize(size), weight: weight)
    }

    static func mono(_ size: CGFloat, weight: UIFont.Weight = .bold) -> UIFont {
        UIFont.monospacedDigitSystemFont(ofSize: ScreenCalipers.glyphSize(size), weight: weight)
    }

    /// Rounded design (iOS 13+, but works on iOS 14 trivially).
    static func rounded(_ size: CGFloat, weight: UIFont.Weight = .heavy) -> UIFont {
        let scaled = ScreenCalipers.glyphSize(size)
        if let blueprint = UIFont.systemFont(ofSize: scaled, weight: weight)
            .fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: blueprint, size: scaled)
        }
        return UIFont.systemFont(ofSize: scaled, weight: weight)
    }
}
