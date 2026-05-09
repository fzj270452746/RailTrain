//
//  ArenaConductor.swift
//  Hosts the SpriteKit play scene plus the overlay HUD.
//

import UIKit
import SpriteKit

final class ArenaConductor: UIViewController {

    private let mode: RailMode
    private let canvas: ArenaCanvas
    private let stage = SKView()
    private let hud: BridgeHud

    private var paused = false

    init(mode: RailMode) {
        self.mode = mode
        self.canvas = ArenaCanvas(mode: mode)
        self.hud = BridgeHud(mode: mode)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) { fatalError() }

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ChromaVault.nightVoid

        stage.translatesAutoresizingMaskIntoConstraints = false
        stage.ignoresSiblingOrder = true
        stage.allowsTransparency = true
        stage.backgroundColor = .clear
        view.addSubview(stage)

        hud.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hud)

        NSLayoutConstraint.activate([
            stage.topAnchor.constraint(equalTo: view.topAnchor),
            stage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            hud.topAnchor.constraint(equalTo: view.topAnchor),
            hud.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hud.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hud.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        canvas.scaleMode = .resizeFill
        canvas.relay = self
        view.layoutIfNeeded()
        canvas.size = stage.bounds.size
        stage.presentScene(canvas)

        hud.onPause = { [weak self] in self?.askPause() }
        hud.onAbort = { [weak self] in self?.askAbort() }
        hud.attach(canvas: canvas)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if canvas.size != stage.bounds.size {
            canvas.size = stage.bounds.size
            canvas.replan()
        }
    }

    private func askPause() {
        guard !paused else { return }
        paused = true
        canvas.haltClock()
        let parchment = RelicCurtain.Verdict.paused(
            resume: { [weak self] in self?.resumeRun() },
            restart: { [weak self] in self?.restartRun() },
            depart: { [weak self] in self?.bail() })
        present(RelicCurtain(parchment), animated: true)
    }

    private func askAbort() {
        let parchment = RelicCurtain.Verdict.confirm(
            banner: "Leave Run?",
            message: "Progress in this run will be lost.",
            ok: "Leave",
            cancel: "Stay",
            okAct: { [weak self] in self?.bail() },
            cancelAct: { })
        present(RelicCurtain(parchment), animated: true)
    }

    private func resumeRun() {
        paused = false
        canvas.resumeClock()
    }

    private func restartRun() {
        paused = false
        canvas.flushAndReset()
    }

    private func bail() {
        dismiss(animated: true)
    }
}

extension ArenaConductor: ArenaRelay {

    func arenaDidUpdate(score: Int, combo: Int, queue: Int) {
        hud.publish(score: score, combo: combo, queue: queue)
    }

    func arenaOrdersChanged(_ orders: [DispatchOrder]) {
        hud.refreshOrders(orders)
    }

    func arenaCountdown(_ seconds: TimeInterval?) {
        hud.publishCountdown(seconds)
    }

    func arenaCapacity(_ ratio: CGFloat, count: Int, cap: Int) {
        hud.publishCapacity(ratio, count: count, cap: cap)
    }

    func arenaConcluded(score: Int, fresh: Bool, sprint: Bool) {
        let parchment: RelicCurtain.Verdict
        if sprint {
            parchment = .sprintEnd(score: score,
                                    fresh: fresh,
                                    retry: { [weak self] in self?.restartRun() },
                                    depart: { [weak self] in self?.bail() })
        } else {
            parchment = .ruin(score: score,
                              fresh: fresh,
                              retry: { [weak self] in self?.restartRun() },
                              depart: { [weak self] in self?.bail() })
        }
        present(RelicCurtain(parchment), animated: true)
    }
}

protocol ArenaRelay: AnyObject {
    func arenaDidUpdate(score: Int, combo: Int, queue: Int)
    func arenaOrdersChanged(_ orders: [DispatchOrder])
    func arenaCountdown(_ seconds: TimeInterval?)
    func arenaCapacity(_ ratio: CGFloat, count: Int, cap: Int)
    func arenaConcluded(score: Int, fresh: Bool, sprint: Bool)
}
