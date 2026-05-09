//
//  DispatchOrder.swift
//

import Foundation

struct DispatchOrder: Equatable {
    let glyph: TileGlyph
    let goal: Int
    var packed: Int
    let bounty: Int

    var done: Bool { packed >= goal }

    static func mint(rankCap: Int) -> DispatchOrder {
        let suit: TileSuit = [.craft, .orb, .bamboo].randomElement() ?? .craft
        let rank = Int.random(in: 1...max(1, rankCap))
        let goal = Int.random(in: 2...4)
        let bounty = (rank * 35) * goal + 60
        return DispatchOrder(glyph: TileGlyph(suit: suit, rank: rank),
                             goal: goal,
                             packed: 0,
                             bounty: bounty)
    }
}
