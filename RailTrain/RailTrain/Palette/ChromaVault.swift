//
//  ChromaVault.swift
//  Color tokens for the entire experience.
//

import UIKit

enum ChromaVault {

    // Backdrops
    static let nightVoid     = UIColor(red: 0.043, green: 0.058, blue: 0.137, alpha: 1.0)
    static let abyssIndigo   = UIColor(red: 0.078, green: 0.094, blue: 0.220, alpha: 1.0)
    static let twilightHaze  = UIColor(red: 0.176, green: 0.180, blue: 0.380, alpha: 1.0)

    // Accents
    static let neonOrchid    = UIColor(red: 0.929, green: 0.286, blue: 0.835, alpha: 1.0)
    static let cyberMint     = UIColor(red: 0.180, green: 0.890, blue: 0.722, alpha: 1.0)
    static let solarHoney    = UIColor(red: 1.000, green: 0.792, blue: 0.235, alpha: 1.0)
    static let coralBlaze    = UIColor(red: 1.000, green: 0.412, blue: 0.408, alpha: 1.0)
    static let tropicLagoon  = UIColor(red: 0.310, green: 0.659, blue: 1.000, alpha: 1.0)
    static let auroraLilac   = UIColor(red: 0.659, green: 0.518, blue: 1.000, alpha: 1.0)

    // Suit hues
    static let craftHue      = UIColor(red: 1.000, green: 0.521, blue: 0.392, alpha: 1.0)
    static let orbHue        = UIColor(red: 0.353, green: 0.722, blue: 1.000, alpha: 1.0)
    static let bambooHue     = UIColor(red: 0.376, green: 0.882, blue: 0.502, alpha: 1.0)
    static let wildHue       = UIColor(red: 1.000, green: 0.812, blue: 0.247, alpha: 1.0)

    // Text
    static let parchmentLite = UIColor.white
    static let parchmentSoft = UIColor(white: 1.0, alpha: 0.78)
    static let parchmentMute = UIColor(white: 1.0, alpha: 0.5)

    // States
    static let cautionEmber  = UIColor(red: 1.000, green: 0.380, blue: 0.380, alpha: 1.0)
    static let verdantOk     = UIColor(red: 0.310, green: 0.890, blue: 0.553, alpha: 1.0)

    static func hueForSuit(_ suit: TileSuit) -> UIColor {
        switch suit {
        case .craft:    return craftHue
        case .orb:      return orbHue
        case .bamboo:   return bambooHue
        case .wildcard: return wildHue
        }
    }
}

extension UIColor {
    func tinged(by ratio: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let mix = max(0, min(1, ratio))
        return UIColor(red: min(1, r + (1 - r) * mix),
                       green: min(1, g + (1 - g) * mix),
                       blue: min(1, b + (1 - b) * mix),
                       alpha: a)
    }

    func dimmed(by ratio: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let mix = 1 - max(0, min(1, ratio))
        return UIColor(red: r * mix, green: g * mix, blue: b * mix, alpha: a)
    }
}
