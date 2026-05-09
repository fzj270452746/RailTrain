//
//  AuroraSheet.swift
//  Reusable gradient backdrop view.
//

import UIKit

final class AuroraSheet: UIView {

    enum Cadence {
        case lobbyDeep
        case panelGloss
        case ribbonHero
        case alertWell

        var stops: [CGColor] {
            switch self {
            case .lobbyDeep:
                return [
                    UIColor(red: 0.04, green: 0.05, blue: 0.18, alpha: 1).cgColor,
                    UIColor(red: 0.10, green: 0.07, blue: 0.32, alpha: 1).cgColor,
                    UIColor(red: 0.18, green: 0.10, blue: 0.45, alpha: 1).cgColor
                ]
            case .panelGloss:
                return [
                    UIColor(white: 1, alpha: 0.16).cgColor,
                    UIColor(white: 1, alpha: 0.04).cgColor
                ]
            case .ribbonHero:
                return [
                    ChromaVault.neonOrchid.cgColor,
                    ChromaVault.tropicLagoon.cgColor,
                    ChromaVault.cyberMint.cgColor
                ]
            case .alertWell:
                return [
                    UIColor(red: 0.10, green: 0.07, blue: 0.30, alpha: 0.96).cgColor,
                    UIColor(red: 0.06, green: 0.05, blue: 0.20, alpha: 0.96).cgColor
                ]
            }
        }

        var anchors: (CGPoint, CGPoint) {
            switch self {
            case .lobbyDeep:  return (CGPoint(x: 0, y: 0),   CGPoint(x: 1, y: 1))
            case .panelGloss: return (CGPoint(x: 0, y: 0),   CGPoint(x: 0, y: 1))
            case .ribbonHero: return (CGPoint(x: 0, y: 0.2), CGPoint(x: 1, y: 0.8))
            case .alertWell:  return (CGPoint(x: 0, y: 0),   CGPoint(x: 1, y: 1))
            }
        }
    }

    private let stratum = CAGradientLayer()

    init(_ cadence: Cadence) {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        stratum.colors = cadence.stops
        let pair = cadence.anchors
        stratum.startPoint = pair.0
        stratum.endPoint = pair.1
        layer.addSublayer(stratum)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        stratum.frame = bounds
    }
}
