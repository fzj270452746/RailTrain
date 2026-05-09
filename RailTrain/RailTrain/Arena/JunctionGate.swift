//
//  JunctionGate.swift
//  Tappable junction node living between two lanes.
//

import SpriteKit

final class JunctionGate: SKShapeNode {

    let idA: Int
    let idB: Int
    let anchor: CGPoint

    init(idA: Int, idB: Int, anchor: CGPoint) {
        self.idA = idA
        self.idB = idB
        self.anchor = anchor
        super.init()
        let radius: CGFloat = ScreenCalipers.slate ? 32 : 26
        path = UIBezierPath(ovalIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2)).cgPath
        fillColor = ChromaVault.tropicLagoon.withAlphaComponent(0.22)
        strokeColor = ChromaVault.cyberMint
        lineWidth = 2
        position = anchor
        zPosition = 5

        let glyph = SKLabelNode(text: "⇄")
        glyph.fontName = "AvenirNext-Heavy"
        glyph.fontSize = ScreenCalipers.slate ? 28 : 22
        glyph.fontColor = ChromaVault.parchmentLite
        glyph.verticalAlignmentMode = .center
        glyph.horizontalAlignmentMode = .center
        addChild(glyph)

        let breathe = SKAction.sequence([
            .scale(to: 1.08, duration: 0.9),
            .scale(to: 0.94, duration: 0.9)
        ])
        breathe.timingMode = .easeInEaseOut
        run(.repeatForever(breathe))
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func contains(_ p: CGPoint) -> Bool {
        let dx = p.x - position.x
        let dy = p.y - position.y
        let radius: CGFloat = ScreenCalipers.slate ? 36 : 30
        return dx * dx + dy * dy <= radius * radius
    }

    func flash() {
        let pulse = SKAction.sequence([
            .scale(to: 1.25, duration: 0.1),
            .scale(to: 1.0, duration: 0.1)
        ])
        run(pulse)

        let halo = SKShapeNode(circleOfRadius: 30)
        halo.strokeColor = ChromaVault.cyberMint
        halo.lineWidth = 2
        halo.fillColor = .clear
        halo.position = .zero
        addChild(halo)
        halo.run(.sequence([
            .group([.scale(to: 2.4, duration: 0.4), .fadeOut(withDuration: 0.4)]),
            .removeFromParent()
        ]))
    }
}
