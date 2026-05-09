//
//  RailMode.swift
//  Game modes the player can pick from the lobby.
//

import Foundation

enum RailMode: Int, CaseIterable {
    case classic
    case sprint
    case dispatch
    case overdrive

    var marquee: String {
        switch self {
        case .classic:   return "Classic"
        case .sprint:    return "Sprint"
        case .dispatch:  return "Dispatch"
        case .overdrive: return "Overdrive"
        }
    }

    var blurb: String {
        switch self {
        case .classic:   return "Endless dispatching. Push for the highest score."
        case .sprint:    return "Three-minute rush. Combos count double."
        case .dispatch:  return "Fulfill consecutive freight orders."
        case .overdrive: return "The rail keeps speeding up. Stay alive."
        }
    }

    var emblem: String {
        switch self {
        case .classic:   return "infinity"
        case .sprint:    return "stopwatch"
        case .dispatch:  return "shippingbox"
        case .overdrive: return "bolt.fill"
        }
    }
}
