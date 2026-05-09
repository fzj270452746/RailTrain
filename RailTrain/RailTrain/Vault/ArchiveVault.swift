//
//  ArchiveVault.swift
//  Local persistence for highscores, settings and tutorial flags.
//

import Foundation

final class ArchiveVault {

    static let shared = ArchiveVault()

    private enum Slot {
        static let bestByMode    = "vault.best.byMode"
        static let aggregateStat = "vault.stats.aggregate"
        static let muteAudio     = "vault.flag.muteAudio"
        static let muteHaptic    = "vault.flag.muteHaptic"
        static let firstRun      = "vault.flag.firstRun"
    }

    private let store = UserDefaults.standard
    private init() {}

    func bootstrap() {
        if store.object(forKey: Slot.firstRun) == nil {
            store.set(true, forKey: Slot.firstRun)
            store.set(false, forKey: Slot.muteAudio)
            store.set(false, forKey: Slot.muteHaptic)
        }
    }

    // MARK: - High scores

    func crest(for mode: RailMode) -> Int {
        let book = store.dictionary(forKey: Slot.bestByMode) as? [String: Int] ?? [:]
        return book["\(mode.rawValue)"] ?? 0
    }

    func enshrine(score: Int, for mode: RailMode) -> Bool {
        var book = store.dictionary(forKey: Slot.bestByMode) as? [String: Int] ?? [:]
        let key = "\(mode.rawValue)"
        let prior = book[key] ?? 0
        guard score > prior else { return false }
        book[key] = score
        store.set(book, forKey: Slot.bestByMode)
        return true
    }

    // MARK: - Aggregate stats

    func aggregate() -> AggregateLedger {
        guard let blob = store.dictionary(forKey: Slot.aggregateStat) else {
            return AggregateLedger()
        }
        return AggregateLedger(
            runs:      blob["runs"]      as? Int ?? 0,
            merges:    blob["merges"]    as? Int ?? 0,
            deliveries:blob["deliveries"]as? Int ?? 0,
            peakCombo: blob["peakCombo"] as? Int ?? 0,
            totalScore:blob["totalScore"]as? Int ?? 0)
    }

    func bind(_ ledger: AggregateLedger) {
        let blob: [String: Any] = [
            "runs":       ledger.runs,
            "merges":     ledger.merges,
            "deliveries": ledger.deliveries,
            "peakCombo":  ledger.peakCombo,
            "totalScore": ledger.totalScore
        ]
        store.set(blob, forKey: Slot.aggregateStat)
    }

    // MARK: - Toggles

    var isAudioMuted: Bool {
        get { store.bool(forKey: Slot.muteAudio) }
        set { store.set(newValue, forKey: Slot.muteAudio) }
    }

    var isHapticMuted: Bool {
        get { store.bool(forKey: Slot.muteHaptic) }
        set { store.set(newValue, forKey: Slot.muteHaptic) }
    }
}

struct AggregateLedger {
    var runs: Int = 0
    var merges: Int = 0
    var deliveries: Int = 0
    var peakCombo: Int = 0
    var totalScore: Int = 0
}
