//
//  TileGlyph.swift
//  Suite of tile suits and ranks used by the rail network.
//

import Foundation

enum TileSuit: Int, CaseIterable {
    case craft   // 万 wan
    case orb     // 筒 circle
    case bamboo  // 条 line
    case wildcard

    var pictogram: String {
        switch self {
        case .craft:    return "Craft"
        case .orb:      return "Orb"
        case .bamboo:   return "Bamboo"
        case .wildcard: return "Wildcard"
        }
    }
}

struct TileGlyph: Equatable, Hashable {
    let suit: TileSuit
    let rank: Int

    static let topRank: Int = 9

    var atlasKey: String {
        switch suit {
        case .craft:    return "rail_wan_\(rank)"
        case .orb:      return "rail_circle_\(rank)"
        case .bamboo:   return "rail_line_\(rank)"
        case .wildcard: return "rail_wild"
        }
    }

    var canStepUp: Bool {
        suit != .wildcard && rank < TileGlyph.topRank
    }

    func bumpedUp() -> TileGlyph {
        guard canStepUp else { return self }
        return TileGlyph(suit: suit, rank: rank + 1)
    }

    static func random(within range: ClosedRange<Int> = 1...3,
                       wildcardOdds: Double = 0.04) -> TileGlyph {
        if Double.random(in: 0...1) < wildcardOdds {
            return TileGlyph(suit: .wildcard, rank: 0)
        }
        let plate: [TileSuit] = [.craft, .orb, .bamboo]
        let suit = plate.randomElement() ?? .craft
        let rank = Int.random(in: range)
        return TileGlyph(suit: suit, rank: rank)
    }
}
