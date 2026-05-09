//
//  LedgerObservatory.swift
//  Aggregated statistics + per-mode bests.
//

import UIKit

final class LedgerObservatory: UIViewController {

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ChromaVault.nightVoid
        let backdrop = AuroraSheet(.lobbyDeep)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdrop)

        let dipBack = EmberPulser(tone: .ghostly, title: "Back", icon: "chevron.left")
        dipBack.translatesAutoresizingMaskIntoConstraints = false
        dipBack.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dipBack)

        let lintel = UILabel()
        lintel.text = "Stats"
        lintel.font = TypeFoundry.rounded(28, weight: .black)
        lintel.textColor = .white
        lintel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lintel)

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = ScreenCalipers.gutter(2)
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dipBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dipBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dipBack.heightAnchor.constraint(equalToConstant: 40),
            dipBack.widthAnchor.constraint(equalToConstant: 96),
            lintel.topAnchor.constraint(equalTo: dipBack.bottomAnchor, constant: 16),
            lintel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scroll.topAnchor.constraint(equalTo: lintel.bottomAnchor, constant: 12),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: ScreenCalipers.slate ? 64 : 24),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: ScreenCalipers.slate ? -64 : -24),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: ScreenCalipers.slate ? -128 : -48)
        ])

        let ledger = ArchiveVault.shared.aggregate()
        stack.addArrangedSubview(GridBlock(caption: "Lifetime", entries: [
            ("Runs", "\(ledger.runs)"),
            ("Merges", "\(ledger.merges)"),
            ("Deliveries", "\(ledger.deliveries)"),
            ("Peak Combo", "x\(ledger.peakCombo)"),
            ("Total Score", "\(ledger.totalScore)")
        ]))

        var bestRows: [(String, String)] = []
        for mode in RailMode.allCases {
            bestRows.append((mode.marquee, "\(ArchiveVault.shared.crest(for: mode))"))
        }
        stack.addArrangedSubview(GridBlock(caption: "Mode Bests", entries: bestRows))
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

private final class GridBlock: UIView {

    init(caption: String, entries: [(String, String)]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        let panel = GlassPanel(mood: .midnight)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        let head = UILabel()
        head.text = caption.uppercased()
        head.font = TypeFoundry.mono(13, weight: .heavy)
        head.textColor = ChromaVault.cyberMint
        head.translatesAutoresizingMaskIntoConstraints = false
        addSubview(head)

        var prior: UIView? = head
        let column = UIStackView()
        column.axis = .vertical
        column.spacing = 10
        column.translatesAutoresizingMaskIntoConstraints = false
        addSubview(column)

        for entry in entries {
            column.addArrangedSubview(LineRow(lhs: entry.0, rhs: entry.1))
        }

        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: topAnchor),
            panel.bottomAnchor.constraint(equalTo: bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: trailingAnchor),
            head.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            head.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            head.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            column.topAnchor.constraint(equalTo: head.bottomAnchor, constant: 12),
            column.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            column.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            column.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        _ = prior
    }

    required init?(coder: NSCoder) { fatalError() }
}

private final class LineRow: UIView {
    init(lhs: String, rhs: String) {
        super.init(frame: .zero)
        let left = UILabel()
        left.text = lhs
        left.font = TypeFoundry.body(15)
        left.textColor = ChromaVault.parchmentSoft
        left.translatesAutoresizingMaskIntoConstraints = false

        let right = UILabel()
        right.text = rhs
        right.font = TypeFoundry.mono(16, weight: .heavy)
        right.textColor = ChromaVault.parchmentLite
        right.textAlignment = .right
        right.translatesAutoresizingMaskIntoConstraints = false

        addSubview(left)
        addSubview(right)
        NSLayoutConstraint.activate([
            left.topAnchor.constraint(equalTo: topAnchor),
            left.bottomAnchor.constraint(equalTo: bottomAnchor),
            left.leadingAnchor.constraint(equalTo: leadingAnchor),
            right.topAnchor.constraint(equalTo: topAnchor),
            right.bottomAnchor.constraint(equalTo: bottomAnchor),
            right.trailingAnchor.constraint(equalTo: trailingAnchor),
            right.leadingAnchor.constraint(greaterThanOrEqualTo: left.trailingAnchor, constant: 8)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
