//
//  ChimeForge.swift
//  Lightweight sound and haptic dispatcher backed by AudioServices system sounds.
//

import UIKit
import AudioToolbox

final class ChimeForge {

    static let shared = ChimeForge()

    enum Pulse {
        case tap
        case merge
        case combo
        case dispatch
        case warning
        case bust
        case shimmer
    }

    private init() {}

    func warmup() {
        _ = ArchiveVault.shared.isAudioMuted
    }

    func ring(_ pulse: Pulse) {
        if !ArchiveVault.shared.isAudioMuted {
            AudioServicesPlaySystemSound(systemId(for: pulse))
        }
        if !ArchiveVault.shared.isHapticMuted {
            tap(for: pulse)
        }
    }

    private func systemId(for pulse: Pulse) -> SystemSoundID {
        switch pulse {
        case .tap:      return 1104
        case .merge:    return 1057
        case .combo:    return 1025
        case .dispatch: return 1117
        case .warning:  return 1006
        case .bust:     return 1053
        case .shimmer:  return 1322
        }
    }

    private func tap(for pulse: Pulse) {
        switch pulse {
        case .tap:
            UISelectionFeedbackGenerator().selectionChanged()
        case .merge:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .combo:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .dispatch:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .bust:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .shimmer:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
}
