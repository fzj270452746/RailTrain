//
//  EmberPulser.swift
//  Custom rounded gradient button with press animation.
//

import UIKit

final class EmberPulser: UIControl {

    enum Tone {
        case primary
        case ghostly
        case caution
        case quiet

        fileprivate var palette: [UIColor] {
            switch self {
            case .primary:  return [ChromaVault.neonOrchid, ChromaVault.tropicLagoon]
            case .ghostly:  return [UIColor(white: 1, alpha: 0.10), UIColor(white: 1, alpha: 0.04)]
            case .caution:  return [ChromaVault.coralBlaze, ChromaVault.solarHoney]
            case .quiet:    return [UIColor(red: 0.12, green: 0.14, blue: 0.30, alpha: 1),
                                    UIColor(red: 0.20, green: 0.24, blue: 0.42, alpha: 1)]
            }
        }

        fileprivate var titleHue: UIColor {
            switch self {
            case .ghostly: return ChromaVault.parchmentLite
            default:       return .white
            }
        }
    }

    private let label = UILabel()
    private let glaze = CAGradientLayer()
    private let stroke = CAShapeLayer()
    private let icon = UIImageView()
    private let tone: Tone

    init(tone: Tone, title: String, icon name: String? = nil) {
        self.tone = tone
        super.init(frame: .zero)

        glaze.colors = tone.palette.map { $0.cgColor }
        glaze.startPoint = CGPoint(x: 0, y: 0)
        glaze.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(glaze)

        stroke.fillColor = UIColor.clear.cgColor
        stroke.strokeColor = UIColor(white: 1, alpha: 0.18).cgColor
        stroke.lineWidth = 1
        layer.addSublayer(stroke)

        label.text = title
        label.textColor = tone.titleHue
        label.font = TypeFoundry.rounded(17, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        if let pin = name {
            icon.image = UIImage(systemName: pin)
            icon.tintColor = tone.titleHue
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            addSubview(icon)
            NSLayoutConstraint.activate([
                icon.centerYAnchor.constraint(equalTo: centerYAnchor),
                icon.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
                icon.widthAnchor.constraint(equalToConstant: 18),
                icon.heightAnchor.constraint(equalToConstant: 18)
            ])
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 13)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }

        addTarget(self, action: #selector(squish), for: [.touchDown])
        addTarget(self, action: #selector(unsquish), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        glaze.frame = bounds
        let curl = ScreenCalipers.cornerSheen(min(bounds.height / 2, 28))
        glaze.cornerRadius = curl
        layer.cornerRadius = curl
        stroke.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5),
                                    cornerRadius: curl).cgPath
        stroke.frame = bounds
    }

    @objc private func squish() {
        UIView.animate(withDuration: 0.08) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.85
        }
    }

    @objc private func unsquish() {
        UIView.animate(withDuration: 0.18,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.6,
                       options: [.allowUserInteraction]) {
            self.transform = .identity
            self.alpha = 1
        }
        ChimeForge.shared.ring(.tap)
    }
}
