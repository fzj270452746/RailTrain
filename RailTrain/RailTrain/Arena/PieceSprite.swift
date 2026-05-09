//
//  PieceSprite.swift
//  A traveling mahjong tile inside the arena.
//

import SpriteKit

final class PieceSprite: SKNode {

    var glyph: TileGlyph
    private(set) var lane: RailLane
    private let plate: SKSpriteNode
    private var halo: SKShapeNode?
    private var bodyHeight: CGFloat
    var moving: Bool = true
    var locked: Bool = false  // for animations

    init(glyph: TileGlyph, lane: RailLane, plateSize: CGSize) {
        self.glyph = glyph
        self.lane = lane
        self.bodyHeight = plateSize.height
        let tex = AtlasMint.mintTexture(for: glyph)
        plate = SKSpriteNode(texture: tex, size: plateSize)
        super.init()
        addChild(plate)
        adornHalo()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    func adornHalo() {
        halo?.removeFromParent()
        let pad: CGFloat = 6
        let aura = SKShapeNode(rectOf: CGSize(width: plate.size.width + pad,
                                              height: plate.size.height + pad),
                               cornerRadius: 12)
        aura.lineWidth = 2
        aura.strokeColor = ChromaVault.hueForSuit(glyph.suit).withAlphaComponent(0.6)
        aura.fillColor = .clear
        aura.zPosition = -1
        addChild(aura)
        halo = aura
    }

    func reswatch(to next: TileGlyph) {
        glyph = next
        plate.texture = AtlasMint.mintTexture(for: next)
        adornHalo()
    }

    func bindLane(_ next: RailLane) {
        lane = next
    }

    func bumpScale(_ factor: CGFloat = 1.18, duration: TimeInterval = 0.18) {
        let up = SKAction.scale(to: factor, duration: duration / 2)
        up.timingMode = .easeOut
        let dn = SKAction.scale(to: 1.0, duration: duration / 2)
        dn.timingMode = .easeIn
        run(SKAction.sequence([up, dn]))
    }

    var bodyRadius: CGFloat { bodyHeight / 2 }
}
