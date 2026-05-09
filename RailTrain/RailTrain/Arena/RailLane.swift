//
//  RailLane.swift
//  Logical lane that holds tiles in order from spawn to dispatch.
//

import SpriteKit

final class RailLane {

    let identifier: Int
    let centerX: CGFloat
    let topY: CGFloat
    let bottomY: CGFloat
    let cap: Int

    private(set) var occupants: [PieceSprite] = []

    init(identifier: Int, centerX: CGFloat, topY: CGFloat, bottomY: CGFloat, cap: Int) {
        self.identifier = identifier
        self.centerX = centerX
        self.topY = topY
        self.bottomY = bottomY
        self.cap = cap
    }

    /// Tiles travel from top → bottom. Front of queue is the lowest sprite.
    func push(_ piece: PieceSprite) {
        occupants.append(piece)
    }

    func pop(_ piece: PieceSprite) {
        occupants.removeAll { $0 === piece }
    }

    var isFull: Bool { occupants.count >= cap }

    var leader: PieceSprite? { occupants.first }

    /// Re-sort occupants so the lowest-y tile is the leader (front of the queue).
    func realign() {
        occupants.sort { $0.position.y < $1.position.y }
    }

    func tileAhead(of piece: PieceSprite) -> PieceSprite? {
        guard let pivot = occupants.firstIndex(where: { $0 === piece }), pivot > 0 else { return nil }
        return occupants[pivot - 1]
    }
}
