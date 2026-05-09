//
//  RelicCurtain.swift
//  Custom modal alert view replacing UIAlertController.
//

import UIKit

final class RelicCurtain: UIViewController {

    struct Verdict {
        let badge: String
        let banner: String
        let message: String
        let cardinal: String
        let auxiliary: String?
        let cardinalAct: () -> Void
        let auxiliaryAct: (() -> Void)?

        static func ruin(score: Int, fresh: Bool, retry: @escaping () -> Void, depart: @escaping () -> Void) -> Verdict {
            Verdict(badge: "exclamationmark.triangle.fill",
                    banner: fresh ? "New Best!" : "Run Halted",
                    message: "Final score: \(score)",
                    cardinal: "Run It Back",
                    auxiliary: "Lobby",
                    cardinalAct: retry,
                    auxiliaryAct: depart)
        }

        static func sprintEnd(score: Int, fresh: Bool, retry: @escaping () -> Void, depart: @escaping () -> Void) -> Verdict {
            Verdict(badge: "stopwatch.fill",
                    banner: fresh ? "New Sprint Best!" : "Sprint Over",
                    message: "Score banked: \(score)",
                    cardinal: "Run Again",
                    auxiliary: "Lobby",
                    cardinalAct: retry,
                    auxiliaryAct: depart)
        }

        static func paused(resume: @escaping () -> Void, restart: @escaping () -> Void, depart: @escaping () -> Void) -> Verdict {
            Verdict(badge: "pause.circle.fill",
                    banner: "Paused",
                    message: "Take a breath, dispatcher.",
                    cardinal: "Resume",
                    auxiliary: "Lobby",
                    cardinalAct: resume,
                    auxiliaryAct: depart)
        }

        static func confirm(banner: String,
                            message: String,
                            ok: String,
                            cancel: String,
                            okAct: @escaping () -> Void,
                            cancelAct: @escaping () -> Void) -> Verdict {
            Verdict(badge: "questionmark.circle.fill",
                    banner: banner,
                    message: message,
                    cardinal: ok,
                    auxiliary: cancel,
                    cardinalAct: okAct,
                    auxiliaryAct: cancelAct)
        }
    }

    private let parchment: Verdict
    private let drape = UIView()
    private let card = GlassPanel(mood: .midnight)

    init(_ parchment: Verdict) {
        self.parchment = parchment
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        drape.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        drape.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drape)
        NSLayoutConstraint.activate([
            drape.topAnchor.constraint(equalTo: view.topAnchor),
            drape.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drape.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drape.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: ScreenCalipers.slate ? 460 : 360),
            card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ScreenCalipers.slate ? 0.55 : 0.84)
        ])

        let badge = UIImageView(image: UIImage(systemName: parchment.badge))
        badge.tintColor = ChromaVault.solarHoney
        badge.contentMode = .scaleAspectFit
        badge.translatesAutoresizingMaskIntoConstraints = false

        let banner = UILabel()
        banner.text = parchment.banner
        banner.font = TypeFoundry.rounded(24, weight: .heavy)
        banner.textColor = .white
        banner.textAlignment = .center
        banner.translatesAutoresizingMaskIntoConstraints = false

        let message = UILabel()
        message.text = parchment.message
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = TypeFoundry.body(15)
        message.textColor = ChromaVault.parchmentSoft
        message.translatesAutoresizingMaskIntoConstraints = false

        let cardinal = EmberPulser(tone: .primary, title: parchment.cardinal)
        cardinal.translatesAutoresizingMaskIntoConstraints = false
        cardinal.addTarget(self, action: #selector(cardinalTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [badge, banner, message, cardinal])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.setCustomSpacing(8, after: badge)
        stack.setCustomSpacing(20, after: message)
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            badge.heightAnchor.constraint(equalToConstant: 42),
            cardinal.heightAnchor.constraint(equalToConstant: 52),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22)
        ])

        if let aux = parchment.auxiliary {
            let auxiliary = EmberPulser(tone: .ghostly, title: aux)
            auxiliary.translatesAutoresizingMaskIntoConstraints = false
            auxiliary.heightAnchor.constraint(equalToConstant: 46).isActive = true
            auxiliary.addTarget(self, action: #selector(auxiliaryTap), for: .touchUpInside)
            stack.addArrangedSubview(auxiliary)
        }

        // Spring entrance
        card.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        card.alpha = 0
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.4,
                       options: []) {
            self.card.transform = .identity
            self.card.alpha = 1
        }
    }

    @objc private func cardinalTap() {
        ChimeForge.shared.ring(.tap)
        dismiss(animated: true) { [parchment] in parchment.cardinalAct() }
    }

    @objc private func auxiliaryTap() {
        ChimeForge.shared.ring(.tap)
        dismiss(animated: true) { [parchment] in parchment.auxiliaryAct?() }
    }
}
