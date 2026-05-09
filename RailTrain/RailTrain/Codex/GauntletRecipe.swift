//
//  GauntletRecipe.swift
//  Per-mode tuning for spawn cadence, speed, and capacity.
//

import Foundation

struct GauntletRecipe {
    let baseSpeed: CGFloat
    let speedDrift: CGFloat
    let spawnGap: TimeInterval
    let spawnFloor: TimeInterval
    let conduitCapacity: Int
    let warningRatio: CGFloat
    let countdown: TimeInterval?
    let orderQueue: Int
    let rankCap: Int

    static func bake(for mode: RailMode) -> GauntletRecipe {
        switch mode {
        case .classic:
            return GauntletRecipe(baseSpeed: 60,
                                  speedDrift: 0.6,
                                  spawnGap: 2.6,
                                  spawnFloor: 1.0,
                                  conduitCapacity: 12,
                                  warningRatio: 0.78,
                                  countdown: nil,
                                  orderQueue: 3,
                                  rankCap: 3)
        case .sprint:
            return GauntletRecipe(baseSpeed: 78,
                                  speedDrift: 0.9,
                                  spawnGap: 2.0,
                                  spawnFloor: 0.8,
                                  conduitCapacity: 11,
                                  warningRatio: 0.78,
                                  countdown: 180,
                                  orderQueue: 3,
                                  rankCap: 3)
        case .dispatch:
            return GauntletRecipe(baseSpeed: 64,
                                  speedDrift: 0.5,
                                  spawnGap: 2.4,
                                  spawnFloor: 1.05,
                                  conduitCapacity: 12,
                                  warningRatio: 0.78,
                                  countdown: nil,
                                  orderQueue: 4,
                                  rankCap: 4)
        case .overdrive:
            return GauntletRecipe(baseSpeed: 70,
                                  speedDrift: 1.6,
                                  spawnGap: 2.2,
                                  spawnFloor: 0.65,
                                  conduitCapacity: 11,
                                  warningRatio: 0.74,
                                  countdown: nil,
                                  orderQueue: 3,
                                  rankCap: 3)
        }
    }
}
