//
//  AtlasMint.swift
//  Lookup helper that returns SKTexture / UIImage for a glyph,
//  with a procedural fallback for missing assets.
//

import UIKit
import SpriteKit

enum AtlasMint {

    private static var cachedTextures: [String: SKTexture] = [:]
    private static var cachedImages: [String: UIImage] = [:]

    static func mintTexture(for glyph: TileGlyph) -> SKTexture {
        if let stash = cachedTextures[glyph.atlasKey] { return stash }
        if let bake = UIImage(named: glyph.atlasKey) {
            let tex = SKTexture(image: bake)
            cachedTextures[glyph.atlasKey] = tex
            return tex
        }
        let drawn = forge(glyph: glyph)
        let tex = SKTexture(image: drawn)
        cachedTextures[glyph.atlasKey] = tex
        return tex
    }

    static func mintImage(for glyph: TileGlyph) -> UIImage {
        if let stash = cachedImages[glyph.atlasKey] { return stash }
        if let bake = UIImage(named: glyph.atlasKey) {
            cachedImages[glyph.atlasKey] = bake
            return bake
        }
        let drawn = forge(glyph: glyph)
        cachedImages[glyph.atlasKey] = drawn
        return drawn
    }

    /// Creates a clean tile if the asset for a glyph is missing.
    private static func forge(glyph: TileGlyph) -> UIImage {
        let canvas = CGSize(width: 180, height: 240)
        let renderer = UIGraphicsImageRenderer(size: canvas)
        return renderer.image { ctx in
            let body = CGRect(x: 6, y: 6, width: canvas.width - 12, height: canvas.height - 12)
            let curl: CGFloat = 26
            let path = UIBezierPath(roundedRect: body, cornerRadius: curl)
            UIColor.white.setFill()
            path.fill()

            // Side face shadow
            UIColor(white: 0.85, alpha: 1).setFill()
            let shadowRect = body.insetBy(dx: 0, dy: 0).offsetBy(dx: 0, dy: 8)
            UIBezierPath(roundedRect: shadowRect, cornerRadius: curl).fill()
            UIColor.white.setFill()
            path.fill()

            let hue = ChromaVault.hueForSuit(glyph.suit)
            let inset = body.insetBy(dx: 18, dy: 24)
            let badge = UIBezierPath(roundedRect: inset, cornerRadius: 18)
            ctx.cgContext.saveGState()
            badge.addClip()
            let space = CGColorSpaceCreateDeviceRGB()
            let grad = CGGradient(colorsSpace: space,
                                  colors: [hue.cgColor,
                                           hue.dimmed(by: 0.2).cgColor] as CFArray,
                                  locations: [0, 1])!
            ctx.cgContext.drawLinearGradient(grad,
                                             start: CGPoint(x: inset.minX, y: inset.minY),
                                             end: CGPoint(x: inset.maxX, y: inset.maxY),
                                             options: [])
            ctx.cgContext.restoreGState()

            let label: String
            if glyph.suit == .wildcard {
                label = "★"
            } else {
                label = "\(glyph.rank)"
            }
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 90, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
            let asize = (label as NSString).size(withAttributes: attrs)
            let origin = CGPoint(x: inset.midX - asize.width / 2,
                                 y: inset.midY - asize.height / 2)
            (label as NSString).draw(at: origin, withAttributes: attrs)
        }
    }
}
