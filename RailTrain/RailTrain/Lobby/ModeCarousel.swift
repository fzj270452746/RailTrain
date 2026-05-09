//
//  ModeCarousel.swift
//  Mode-selection screen.
//

import UIKit

final class ModeCarousel: UIViewController {

    private let backdrop = AuroraSheet(.lobbyDeep)
    private let railSheet = UIScrollView()
    private let stack = UIStackView()
    private let lintel = UILabel()
    private let dipBack = EmberPulser(tone: .ghostly, title: "Back", icon: "chevron.left")

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ChromaVault.nightVoid
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdrop)

        lintel.text = "Pick Your Run"
        lintel.font = TypeFoundry.rounded(28, weight: .black)
        lintel.textColor = .white
        lintel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lintel)

        dipBack.translatesAutoresizingMaskIntoConstraints = false
        dipBack.addTarget(self, action: #selector(dimiss), for: .touchUpInside)
        view.addSubview(dipBack)

        railSheet.translatesAutoresizingMaskIntoConstraints = false
        railSheet.showsVerticalScrollIndicator = false
        view.addSubview(railSheet)

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = ScreenCalipers.gutter(2)
        stack.translatesAutoresizingMaskIntoConstraints = false
        railSheet.addSubview(stack)

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

            railSheet.topAnchor.constraint(equalTo: lintel.bottomAnchor, constant: 12),
            railSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            railSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            railSheet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stack.topAnchor.constraint(equalTo: railSheet.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: railSheet.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: railSheet.leadingAnchor, constant: ScreenCalipers.slate ? 64 : 24),
            stack.trailingAnchor.constraint(equalTo: railSheet.trailingAnchor, constant: ScreenCalipers.slate ? -64 : -24),
            stack.widthAnchor.constraint(equalTo: railSheet.widthAnchor, constant: ScreenCalipers.slate ? -128 : -48)
        ])

        for mode in RailMode.allCases {
            let card = ModeTilePillar(mode: mode)
            card.heightAnchor.constraint(equalToConstant: 132).isActive = true
            card.onTap = { [weak self] picked in
                self?.launchRun(picked)
            }
            stack.addArrangedSubview(card)
        }
    }

    @objc private func dimiss() {
        dismiss(animated: true)
    }

    private func launchRun(_ mode: RailMode) {
        let bridge = ArenaConductor(mode: mode)
        bridge.modalPresentationStyle = .fullScreen
        present(bridge, animated: true)
    }
}

final class ModeTilePillar: UIControl {

    var onTap: ((RailMode) -> Void)?

    private let mode: RailMode
    private let panel = GlassPanel(mood: .midnight)
    private let badge = UIImageView()
    private let title = UILabel()
    private let blurb = UILabel()
    private let bestPill = UILabel()

    init(mode: RailMode) {
        self.mode = mode
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.isUserInteractionEnabled = false
        addSubview(panel)
        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: topAnchor),
            panel.bottomAnchor.constraint(equalTo: bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        badge.image = UIImage(systemName: mode.emblem)
        badge.tintColor = ChromaVault.solarHoney
        badge.contentMode = .scaleAspectFit
        badge.translatesAutoresizingMaskIntoConstraints = false

        title.text = mode.marquee
        title.font = TypeFoundry.rounded(22, weight: .heavy)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false

        blurb.text = mode.blurb
        blurb.numberOfLines = 0
        blurb.font = TypeFoundry.body(13)
        blurb.textColor = ChromaVault.parchmentSoft
        blurb.translatesAutoresizingMaskIntoConstraints = false

        bestPill.font = TypeFoundry.mono(12, weight: .heavy)
        bestPill.textColor = ChromaVault.cyberMint
        bestPill.text = "BEST  \(ArchiveVault.shared.crest(for: mode))"
        bestPill.translatesAutoresizingMaskIntoConstraints = false

        addSubview(badge)
        addSubview(title)
        addSubview(blurb)
        addSubview(bestPill)

        NSLayoutConstraint.activate([
            badge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            badge.centerYAnchor.constraint(equalTo: centerYAnchor),
            badge.widthAnchor.constraint(equalToConstant: 42),
            badge.heightAnchor.constraint(equalToConstant: 42),

            title.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: badge.trailingAnchor, constant: 14),
            title.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            blurb.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            blurb.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            blurb.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            bestPill.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            bestPill.leadingAnchor.constraint(equalTo: title.leadingAnchor)
        ])

        addTarget(self, action: #selector(tap), for: .touchUpInside)
        addTarget(self, action: #selector(squish), for: [.touchDown])
        addTarget(self, action: #selector(unsquish), for: [.touchUpOutside, .touchCancel])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func tap() {
        unsquish()
        ChimeForge.shared.ring(.tap)
        onTap?(mode)
    }

    @objc private func squish() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func unsquish() {
        UIView.animate(withDuration: 0.18,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.5,
                       options: []) {
            self.transform = .identity
        }
    }
}
