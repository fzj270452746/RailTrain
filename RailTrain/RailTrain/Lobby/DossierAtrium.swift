//
//  DossierAtrium.swift
//  How to play screen.
//

import UIKit

final class DossierAtrium: UIViewController {

    private let backdrop = AuroraSheet(.lobbyDeep)
    private let scroll = UIScrollView()
    private let stack = UIStackView()

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ChromaVault.nightVoid

        backdrop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdrop)

        let dipBack = EmberPulser(tone: .ghostly, title: "Back", icon: "chevron.left")
        dipBack.translatesAutoresizingMaskIntoConstraints = false
        dipBack.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dipBack)

        let lintel = UILabel()
        lintel.text = "How To Play"
        lintel.font = TypeFoundry.rounded(28, weight: .black)
        lintel.textColor = .white
        lintel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lintel)

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)

        stack.axis = .vertical
        stack.alignment = .fill
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

        for item in roster {
            stack.addArrangedSubview(LeafletBlock(emblem: item.0, title: item.1, body: item.2))
        }
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    private let roster: [(String, String, String)] = [
        ("hand.tap.fill",
         "Switch the Track",
         "Tap a glowing junction to flip its rail. Send tiles toward matching twins to merge them."),
        ("rectangle.connected.to.line.below",
         "Merge & Climb",
         "Two identical tiles fuse into the next rank. Stack chain merges to feed the combo meter."),
        ("shippingbox.fill",
         "Fulfill Orders",
         "Each run lists target tiles. Push them through the dispatch gate to bank rewards."),
        ("flame.fill",
         "Avoid Bust",
         "Each track has a capacity. If a lane jams, the run ends. Drain it with merges or dispatch."),
        ("sparkles",
         "Wildcards",
         "Golden wildcards merge with any tile to create a higher rank of the partner's suit.")
    ]
}

private final class LeafletBlock: UIView {

    init(emblem: String, title: String, body: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let panel = GlassPanel(mood: .midnight)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        let icon = UIImageView(image: UIImage(systemName: emblem))
        icon.tintColor = ChromaVault.cyberMint
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        let head = UILabel()
        head.text = title
        head.font = TypeFoundry.rounded(18, weight: .heavy)
        head.textColor = .white
        head.translatesAutoresizingMaskIntoConstraints = false

        let copy = UILabel()
        copy.text = body
        copy.numberOfLines = 0
        copy.font = TypeFoundry.body(14)
        copy.textColor = ChromaVault.parchmentSoft
        copy.translatesAutoresizingMaskIntoConstraints = false

        addSubview(icon)
        addSubview(head)
        addSubview(copy)

        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: topAnchor),
            panel.bottomAnchor.constraint(equalTo: bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: trailingAnchor),

            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28),

            head.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            head.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            head.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            copy.topAnchor.constraint(equalTo: head.bottomAnchor, constant: 6),
            copy.leadingAnchor.constraint(equalTo: head.leadingAnchor),
            copy.trailingAnchor.constraint(equalTo: head.trailingAnchor),
            copy.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
