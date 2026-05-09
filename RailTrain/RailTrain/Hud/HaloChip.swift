//
//  HaloChip.swift
//  Compact info chip for tags / suit indicators.
//

import UIKit

final class HaloChip: UIView {

    private let label = UILabel()
    private let glow = CAGradientLayer()

    init(text: String, hue: UIColor) {
        super.init(frame: .zero)
        glow.colors = [hue.withAlphaComponent(0.35).cgColor,
                       hue.withAlphaComponent(0.15).cgColor]
        glow.startPoint = CGPoint(x: 0, y: 0)
        glow.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(glow)
        layer.borderColor = hue.withAlphaComponent(0.6).cgColor
        layer.borderWidth = 1

        label.text = text
        label.textColor = hue.tinged(by: 0.45)
        label.font = TypeFoundry.rounded(11, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        glow.frame = bounds
        let curl = bounds.height / 2
        glow.cornerRadius = curl
        layer.cornerRadius = curl
    }
}
