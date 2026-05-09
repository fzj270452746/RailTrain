//
//  BridgeHud.swift
//  Top + bottom HUD overlay.
//

import UIKit
import SpriteKit

final class BridgeHud: UIView {

    var onPause: (() -> Void)?
    var onAbort: (() -> Void)?

    private let topPanel = GlassPanel(mood: .midnight)
    private let scoreVal = UILabel()
    private let scoreCap = UILabel()
    private let comboVal = UILabel()
    private let queueVal = UILabel()
    private let timerVal = UILabel()
    private let timerCap = UILabel()
    private let capacityBar = CapacityBar()
    private let capacityCount = UILabel()

    private let leaveBtn = EmberPulser(tone: .ghostly, title: "Leave", icon: "xmark")
    private let pauseBtn = EmberPulser(tone: .ghostly, title: "Pause", icon: "pause.fill")

    private let orderRail = UIStackView()
    private let mode: RailMode

    init(mode: RailMode) {
        self.mode = mode
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = true

        compose()
    }

    required init?(coder: NSCoder) { fatalError() }

    /// Pass touches in empty regions through to the SpriteKit scene below.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit === self ? nil : hit
    }

    private func compose() {
        topPanel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topPanel)

        leaveBtn.translatesAutoresizingMaskIntoConstraints = false
        leaveBtn.addTarget(self, action: #selector(tapAbort), for: .touchUpInside)
        addSubview(leaveBtn)

        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        pauseBtn.addTarget(self, action: #selector(tapPause), for: .touchUpInside)
        addSubview(pauseBtn)

        scoreCap.text = "SCORE"
        scoreCap.font = TypeFoundry.mono(10, weight: .heavy)
        scoreCap.textColor = ChromaVault.parchmentMute
        scoreCap.translatesAutoresizingMaskIntoConstraints = false

        scoreVal.text = "0"
        scoreVal.font = TypeFoundry.rounded(20, weight: .heavy)
        scoreVal.textColor = .white
        scoreVal.translatesAutoresizingMaskIntoConstraints = false

        comboVal.text = "x0"
        comboVal.font = TypeFoundry.rounded(15, weight: .heavy)
        comboVal.textColor = ChromaVault.solarHoney
        comboVal.translatesAutoresizingMaskIntoConstraints = false

        queueVal.text = "0/0"
        queueVal.font = TypeFoundry.mono(11, weight: .heavy)
        queueVal.textColor = ChromaVault.parchmentSoft
        queueVal.translatesAutoresizingMaskIntoConstraints = false

        timerCap.text = mode == .sprint ? "TIME" : ""
        timerCap.font = TypeFoundry.mono(10, weight: .heavy)
        timerCap.textColor = ChromaVault.parchmentMute
        timerCap.translatesAutoresizingMaskIntoConstraints = false

        timerVal.text = ""
        timerVal.font = TypeFoundry.rounded(15, weight: .heavy)
        timerVal.textColor = ChromaVault.cyberMint
        timerVal.translatesAutoresizingMaskIntoConstraints = false

        capacityBar.translatesAutoresizingMaskIntoConstraints = false
        capacityCount.text = "0/0"
        capacityCount.font = TypeFoundry.mono(11, weight: .bold)
        capacityCount.textColor = ChromaVault.parchmentSoft
        capacityCount.translatesAutoresizingMaskIntoConstraints = false

        topPanel.addSubview(scoreCap)
        topPanel.addSubview(scoreVal)
        topPanel.addSubview(comboVal)
        topPanel.addSubview(queueVal)
        topPanel.addSubview(timerCap)
        topPanel.addSubview(timerVal)
        topPanel.addSubview(capacityBar)
        topPanel.addSubview(capacityCount)

        let topInset = ScreenCalipers.safeInsets.top + 8

        NSLayoutConstraint.activate([
            leaveBtn.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            leaveBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leaveBtn.heightAnchor.constraint(equalToConstant: 38),
            leaveBtn.widthAnchor.constraint(equalToConstant: 92),

            pauseBtn.topAnchor.constraint(equalTo: leaveBtn.topAnchor),
            pauseBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            pauseBtn.heightAnchor.constraint(equalToConstant: 38),
            pauseBtn.widthAnchor.constraint(equalToConstant: 102),

            topPanel.topAnchor.constraint(equalTo: leaveBtn.bottomAnchor, constant: 8),
            topPanel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            topPanel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            topPanel.heightAnchor.constraint(equalToConstant: 72),

            scoreCap.topAnchor.constraint(equalTo: topPanel.topAnchor, constant: 8),
            scoreCap.leadingAnchor.constraint(equalTo: topPanel.leadingAnchor, constant: 14),
            scoreVal.topAnchor.constraint(equalTo: scoreCap.bottomAnchor, constant: 0),
            scoreVal.leadingAnchor.constraint(equalTo: scoreCap.leadingAnchor),

            comboVal.centerYAnchor.constraint(equalTo: scoreVal.centerYAnchor),
            comboVal.leadingAnchor.constraint(equalTo: scoreVal.trailingAnchor, constant: 10),

            timerCap.topAnchor.constraint(equalTo: scoreCap.topAnchor),
            timerCap.trailingAnchor.constraint(equalTo: topPanel.trailingAnchor, constant: -14),
            timerVal.topAnchor.constraint(equalTo: timerCap.bottomAnchor, constant: 0),
            timerVal.trailingAnchor.constraint(equalTo: timerCap.trailingAnchor),

            queueVal.centerYAnchor.constraint(equalTo: timerVal.centerYAnchor),
            queueVal.trailingAnchor.constraint(equalTo: timerVal.leadingAnchor, constant: -10),

            capacityBar.bottomAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: -8),
            capacityBar.leadingAnchor.constraint(equalTo: topPanel.leadingAnchor, constant: 14),
            capacityBar.trailingAnchor.constraint(equalTo: topPanel.trailingAnchor, constant: -66),
            capacityBar.heightAnchor.constraint(equalToConstant: 6),

            capacityCount.centerYAnchor.constraint(equalTo: capacityBar.centerYAnchor),
            capacityCount.trailingAnchor.constraint(equalTo: topPanel.trailingAnchor, constant: -14),
            capacityCount.leadingAnchor.constraint(equalTo: capacityBar.trailingAnchor, constant: 6)
        ])

        // Order rail at bottom
        orderRail.axis = .horizontal
        orderRail.spacing = 10
        orderRail.alignment = .center
        orderRail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(orderRail)
        NSLayoutConstraint.activate([
            orderRail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ScreenCalipers.safeInsets.bottom - 12),
            orderRail.centerXAnchor.constraint(equalTo: centerXAnchor),
            orderRail.heightAnchor.constraint(equalToConstant: 70),
            orderRail.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 12),
            orderRail.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])
    }

    func attach(canvas: ArenaCanvas) {
        canvas.dispatchSpot = { [weak self] in
            guard let self = self, let last = self.orderRail.arrangedSubviews.first as? OrderTab else {
                return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height - 60)
            }
            return last.convert(CGPoint(x: last.bounds.midX, y: last.bounds.midY), to: nil)
        }
    }

    @objc private func tapAbort() { onAbort?() }
    @objc private func tapPause() { onPause?() }

    func publish(score: Int, combo: Int, queue: Int) {
        scoreVal.text = "\(score)"
        comboVal.text = combo > 1 ? "x\(combo)" : ""
        queueVal.text = "queue \(queue)"
    }

    func publishCountdown(_ seconds: TimeInterval?) {
        guard let seconds = seconds else {
            timerVal.text = ""
            timerCap.text = ""
            return
        }
        let total = max(0, Int(ceil(seconds)))
        let minute = total / 60
        let leftover = total % 60
        timerVal.text = String(format: "%d:%02d", minute, leftover)
        timerCap.text = "TIME"
        timerVal.textColor = total <= 10 ? ChromaVault.cautionEmber : ChromaVault.cyberMint
    }

    func publishCapacity(_ ratio: CGFloat, count: Int, cap: Int) {
        capacityBar.set(ratio: ratio)
        capacityCount.text = "\(count)/\(cap)"
        capacityCount.textColor = ratio >= 0.85 ? ChromaVault.cautionEmber : ChromaVault.parchmentSoft
    }

    func refreshOrders(_ orders: [DispatchOrder]) {
        orderRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for order in orders {
            let tab = OrderTab(order: order)
            orderRail.addArrangedSubview(tab)
        }
    }
}

private final class CapacityBar: UIView {
    private let track = CALayer()
    private let fill = CAGradientLayer()
    private var ratio: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        track.backgroundColor = UIColor(white: 1, alpha: 0.12).cgColor
        layer.addSublayer(track)
        fill.colors = [ChromaVault.cyberMint.cgColor, ChromaVault.solarHoney.cgColor, ChromaVault.coralBlaze.cgColor]
        fill.locations = [0.0, 0.5, 1.0]
        fill.startPoint = CGPoint(x: 0, y: 0.5)
        fill.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(fill)
    }
    required init?(coder: NSCoder) { fatalError() }

    func set(ratio v: CGFloat) {
        ratio = max(0, min(1, v))
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let curl = bounds.height / 2
        track.frame = bounds
        track.cornerRadius = curl
        let prog = CGRect(x: 0, y: 0, width: bounds.width * ratio, height: bounds.height)
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.18)
        fill.frame = prog
        CATransaction.commit()
        fill.cornerRadius = curl
    }
}

final class OrderTab: UIView {
    let order: DispatchOrder

    private let chip = UIImageView()
    private let count = UILabel()
    private let bounty = UILabel()
    private let tile = UIImageView()

    init(order: DispatchOrder) {
        self.order = order
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        let panel = GlassPanel(mood: .midnight)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        tile.image = AtlasMint.mintImage(for: order.glyph)
        tile.contentMode = .scaleAspectFit
        tile.translatesAutoresizingMaskIntoConstraints = false

        count.text = "\(order.packed)/\(order.goal)"
        count.font = TypeFoundry.mono(13, weight: .heavy)
        count.textColor = order.done ? ChromaVault.verdantOk : .white
        count.translatesAutoresizingMaskIntoConstraints = false

        bounty.text = "+\(order.bounty)"
        bounty.font = TypeFoundry.mono(10, weight: .bold)
        bounty.textColor = ChromaVault.solarHoney
        bounty.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tile)
        addSubview(count)
        addSubview(bounty)

        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: topAnchor),
            panel.bottomAnchor.constraint(equalTo: bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: trailingAnchor),

            widthAnchor.constraint(equalToConstant: 110),
            heightAnchor.constraint(equalToConstant: 70),

            tile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tile.centerYAnchor.constraint(equalTo: centerYAnchor),
            tile.widthAnchor.constraint(equalToConstant: 40),
            tile.heightAnchor.constraint(equalToConstant: 54),

            count.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            count.leadingAnchor.constraint(equalTo: tile.trailingAnchor, constant: 6),
            count.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -6),

            bounty.topAnchor.constraint(equalTo: count.bottomAnchor, constant: 4),
            bounty.leadingAnchor.constraint(equalTo: count.leadingAnchor)
        ])
        chip.image = nil
        _ = chip
    }
    required init?(coder: NSCoder) { fatalError() }
}
