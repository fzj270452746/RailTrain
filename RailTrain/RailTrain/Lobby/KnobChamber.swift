//
//  KnobChamber.swift
//  Settings: audio, haptics, reset.
//

import UIKit

final class KnobChamber: UIViewController {

    private let soundPanel = TogglePanel(caption: "Sound Effects",
                                         blurb: "System chimes for merges and warnings.",
                                         on: !ArchiveVault.shared.isAudioMuted)
    private let hapticPanel = TogglePanel(caption: "Haptics",
                                          blurb: "Subtle taps during critical actions.",
                                          on: !ArchiveVault.shared.isHapticMuted)

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
        lintel.text = "Settings"
        lintel.font = TypeFoundry.rounded(28, weight: .black)
        lintel.textColor = .white
        lintel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lintel)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = ScreenCalipers.gutter(2)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        soundPanel.onFlip = { flag in ArchiveVault.shared.isAudioMuted = !flag; ChimeForge.shared.ring(.tap) }
        hapticPanel.onFlip = { flag in ArchiveVault.shared.isHapticMuted = !flag }

        let wipe = EmberPulser(tone: .caution, title: "Reset Progress", icon: "arrow.counterclockwise")
        wipe.translatesAutoresizingMaskIntoConstraints = false
        wipe.addTarget(self, action: #selector(askWipe), for: .touchUpInside)

        let creditsCard = GlassPanel(mood: .midnight)
        creditsCard.translatesAutoresizingMaskIntoConstraints = false
        let creditsText = UILabel()
        creditsText.numberOfLines = 0
        creditsText.text = "Mahjong Rail Train\nVersion 1.0\n\nAn arcade dispatcher where mahjong meets metro logistics. Think fast. Switch tracks. Keep the line alive."
        creditsText.textColor = ChromaVault.parchmentSoft
        creditsText.font = TypeFoundry.body(13)
        creditsText.translatesAutoresizingMaskIntoConstraints = false
        creditsCard.addSubview(creditsText)
        NSLayoutConstraint.activate([
            creditsText.topAnchor.constraint(equalTo: creditsCard.topAnchor, constant: 16),
            creditsText.bottomAnchor.constraint(equalTo: creditsCard.bottomAnchor, constant: -16),
            creditsText.leadingAnchor.constraint(equalTo: creditsCard.leadingAnchor, constant: 18),
            creditsText.trailingAnchor.constraint(equalTo: creditsCard.trailingAnchor, constant: -18)
        ])

        [soundPanel, hapticPanel, creditsCard, wipe].forEach { stack.addArrangedSubview($0) }
        wipe.heightAnchor.constraint(equalToConstant: 52).isActive = true

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

            stack.topAnchor.constraint(equalTo: lintel.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenCalipers.slate ? 80 : 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ScreenCalipers.slate ? -80 : -24)
        ])
    }

    @objc private func close() { dismiss(animated: true) }

    @objc private func askWipe() {
        let parchment = RelicCurtain.Verdict.confirm(
            banner: "Reset Progress?",
            message: "All best scores, stats and settings will be wiped.",
            ok: "Reset",
            cancel: "Keep",
            okAct: { [weak self] in self?.performWipe() },
            cancelAct: { })
        present(RelicCurtain(parchment), animated: true)
    }

    private func performWipe() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("vault.") {
            defaults.removeObject(forKey: key)
        }
        ArchiveVault.shared.bootstrap()
        soundPanel.set(on: !ArchiveVault.shared.isAudioMuted)
        hapticPanel.set(on: !ArchiveVault.shared.isHapticMuted)
        ChimeForge.shared.ring(.warning)
    }
}

private final class TogglePanel: UIView {
    var onFlip: ((Bool) -> Void)?
    private let slide = UISwitch()
    private let head = UILabel()
    private let body = UILabel()

    init(caption: String, blurb: String, on: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let panel = GlassPanel(mood: .midnight)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        head.text = caption
        head.font = TypeFoundry.rounded(17, weight: .heavy)
        head.textColor = .white
        head.translatesAutoresizingMaskIntoConstraints = false

        body.text = blurb
        body.numberOfLines = 0
        body.font = TypeFoundry.body(13)
        body.textColor = ChromaVault.parchmentSoft
        body.translatesAutoresizingMaskIntoConstraints = false

        slide.onTintColor = ChromaVault.cyberMint
        slide.isOn = on
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.addTarget(self, action: #selector(flip), for: .valueChanged)

        addSubview(head)
        addSubview(body)
        addSubview(slide)

        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: topAnchor),
            panel.bottomAnchor.constraint(equalTo: bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: trailingAnchor),

            head.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            head.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            head.trailingAnchor.constraint(equalTo: slide.leadingAnchor, constant: -10),

            body.topAnchor.constraint(equalTo: head.bottomAnchor, constant: 4),
            body.leadingAnchor.constraint(equalTo: head.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: head.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            slide.centerYAnchor.constraint(equalTo: centerYAnchor),
            slide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func set(on: Bool) { slide.isOn = on }

    @objc private func flip() { onFlip?(slide.isOn) }
}
