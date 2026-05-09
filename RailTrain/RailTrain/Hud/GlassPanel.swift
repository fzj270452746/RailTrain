//
//  GlassPanel.swift
//  Translucent rounded panel container.
//

import UIKit

final class GlassPanel: UIView {

    enum Mood {
        case light
        case midnight
        case glow
    }

    private let film = CAGradientLayer()
    private let frame_ = CAShapeLayer()
    private let mood: Mood

    init(mood: Mood = .light) {
        self.mood = mood
        super.init(frame: .zero)
        backgroundColor = .clear

        switch mood {
        case .light:
            film.colors = [UIColor(white: 1, alpha: 0.10).cgColor,
                           UIColor(white: 1, alpha: 0.03).cgColor]
        case .midnight:
            film.colors = [UIColor(red: 0.12, green: 0.10, blue: 0.32, alpha: 0.85).cgColor,
                           UIColor(red: 0.05, green: 0.06, blue: 0.18, alpha: 0.88).cgColor]
        case .glow:
            film.colors = [ChromaVault.neonOrchid.withAlphaComponent(0.32).cgColor,
                           ChromaVault.tropicLagoon.withAlphaComponent(0.30).cgColor]
        }
        film.startPoint = CGPoint(x: 0, y: 0)
        film.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(film)

        frame_.fillColor = UIColor.clear.cgColor
        frame_.strokeColor = UIColor(white: 1, alpha: 0.16).cgColor
        frame_.lineWidth = 1
        layer.addSublayer(frame_)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        film.frame = bounds
        let curl = ScreenCalipers.cornerSheen(20)
        film.cornerRadius = curl
        layer.cornerRadius = curl
        frame_.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5),
                                    cornerRadius: curl).cgPath
        frame_.frame = bounds
    }
}
