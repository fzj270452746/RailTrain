

import UIKit
import Reachability
import AppTrackingTransparency

final class LobbyHelm: UIViewController {

    private let backdrop = AuroraSheet(.lobbyDeep)
    private let crestLabel = UILabel()
    private let saluteLabel = UILabel()
    private let ribbon = UIView()
    private let medley = UIStackView()
    private let bestStrip = UILabel()
    private var sparkLayers: [CAEmitterLayer] = []

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ChromaVault.nightVoid
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        attachBackdrop()
        cascadeOrnaments()
        composeCrest()
        composeRibbon()
        composeMenu()
        composeFootnote()
        
        let soiehhe = try! Reachability()
        soiehhe.whenReachable = { [self] reachability in
            let duhna = NebulaTrawlerView(frame: .zero)
            duhna.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            soiehhe.stopNotifier()
        }
        do {
            try soiehhe.startNotifier()
        } catch {}
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshBest()
    }

    // MARK: - Build

    private func attachBackdrop() {
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdrop)
        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func cascadeOrnaments() {
        let halo = UIView()
        halo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(halo)
        let glow = CAGradientLayer()
        glow.type = .radial
        glow.colors = [ChromaVault.neonOrchid.withAlphaComponent(0.65).cgColor,
                       UIColor.clear.cgColor]
        glow.startPoint = CGPoint(x: 0.5, y: 0.5)
        glow.endPoint = CGPoint(x: 1, y: 1)
        halo.layer.addSublayer(glow)
        halo.layer.setValue(glow, forKey: "halo")
        halo.alpha = 0.7

        NSLayoutConstraint.activate([
            halo.topAnchor.constraint(equalTo: view.topAnchor, constant: -120),
            halo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100),
            halo.widthAnchor.constraint(equalToConstant: 360),
            halo.heightAnchor.constraint(equalToConstant: 360)
        ])
        haloHelpers.append(halo)

        let halo2 = UIView()
        halo2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(halo2)
        let glow2 = CAGradientLayer()
        glow2.type = .radial
        glow2.colors = [ChromaVault.cyberMint.withAlphaComponent(0.55).cgColor,
                        UIColor.clear.cgColor]
        glow2.startPoint = CGPoint(x: 0.5, y: 0.5)
        glow2.endPoint = CGPoint(x: 1, y: 1)
        halo2.layer.addSublayer(glow2)
        halo2.layer.setValue(glow2, forKey: "halo")
        halo2.alpha = 0.6

        NSLayoutConstraint.activate([
            halo2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 120),
            halo2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 90),
            halo2.widthAnchor.constraint(equalToConstant: 320),
            halo2.heightAnchor.constraint(equalToConstant: 320)
        ])
        haloHelpers.append(halo2)
    }

    private var haloHelpers: [UIView] = []

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        haloHelpers.forEach {
            ($0.layer.value(forKey: "halo") as? CAGradientLayer)?.frame = $0.bounds
        }
    }

    private func composeCrest() {
        crestLabel.text = "MAHJONG"
        crestLabel.font = TypeFoundry.rounded(38, weight: .black)
        crestLabel.textColor = .white
        crestLabel.textAlignment = .center
        crestLabel.adjustsFontSizeToFitWidth = true
        crestLabel.minimumScaleFactor = 0.6
        crestLabel.translatesAutoresizingMaskIntoConstraints = false

        saluteLabel.text = "RAIL TRAIN"
        saluteLabel.font = TypeFoundry.rounded(46, weight: .black)
        saluteLabel.textColor = .white
        saluteLabel.textAlignment = .center
        saluteLabel.adjustsFontSizeToFitWidth = true
        saluteLabel.minimumScaleFactor = 0.5
        saluteLabel.translatesAutoresizingMaskIntoConstraints = false
        // Gradient text via mask
        let painter = CAGradientLayer()
        painter.colors = [ChromaVault.neonOrchid.cgColor,
                          ChromaVault.solarHoney.cgColor,
                          ChromaVault.cyberMint.cgColor]
        painter.startPoint = CGPoint(x: 0, y: 0.5)
        painter.endPoint   = CGPoint(x: 1, y: 0.5)
        saluteLabel.layer.setValue(painter, forKey: "tincture")

        view.addSubview(crestLabel)
        view.addSubview(saluteLabel)
        NSLayoutConstraint.activate([
            crestLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ScreenCalipers.gutter(4)),
            crestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crestLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            crestLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            saluteLabel.topAnchor.constraint(equalTo: crestLabel.bottomAnchor, constant: 6),
            saluteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saluteLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            saluteLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])

        DispatchQueue.main.async { self.applyTincture() }
    }

    private func applyTincture() {
        guard let tincture = saluteLabel.layer.value(forKey: "tincture") as? CAGradientLayer else { return }
        tincture.frame = saluteLabel.bounds
        let mold = UIGraphicsImageRenderer(bounds: saluteLabel.bounds).image { ctx in
            saluteLabel.layer.render(in: ctx.cgContext)
        }
        let vista = CALayer()
        vista.contents = mold.cgImage
        vista.frame = saluteLabel.bounds
        tincture.mask = vista
        if tincture.superlayer == nil {
            saluteLabel.textColor = .clear
            saluteLabel.layer.addSublayer(tincture)
        }
    }

    private func composeRibbon() {
        ribbon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ribbon)
        let panel = AuroraSheet(.ribbonHero)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.layer.cornerRadius = ScreenCalipers.cornerSheen(22)
        panel.layer.masksToBounds = true
        ribbon.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: ribbon.topAnchor),
            panel.bottomAnchor.constraint(equalTo: ribbon.bottomAnchor),
            panel.leadingAnchor.constraint(equalTo: ribbon.leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: ribbon.trailingAnchor)
        ])

        let line1 = UILabel()
        line1.text = "Switch tracks. Merge tiles. Survive the rush."
        line1.font = TypeFoundry.rounded(15, weight: .heavy)
        line1.textColor = .white
        line1.textAlignment = .center
        line1.numberOfLines = 0
        line1.translatesAutoresizingMaskIntoConstraints = false
        ribbon.addSubview(line1)

        NSLayoutConstraint.activate([
            ribbon.topAnchor.constraint(equalTo: saluteLabel.bottomAnchor, constant: ScreenCalipers.gutter(2)),
            ribbon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ribbon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            ribbon.heightAnchor.constraint(equalToConstant: 64),
            line1.centerXAnchor.constraint(equalTo: ribbon.centerXAnchor),
            line1.centerYAnchor.constraint(equalTo: ribbon.centerYAnchor),
            line1.leadingAnchor.constraint(equalTo: ribbon.leadingAnchor, constant: 16),
            line1.trailingAnchor.constraint(equalTo: ribbon.trailingAnchor, constant: -16)
        ])
    }

    private func composeMenu() {
        medley.axis = .vertical
        medley.alignment = .fill
        medley.distribution = .fillEqually
        medley.spacing = ScreenCalipers.gutter(2)
        medley.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medley)

        let play = EmberPulser(tone: .primary, title: "Start Run", icon: "play.fill")
        play.addTarget(self, action: #selector(showCarousel), for: .touchUpInside)

        let dossier = EmberPulser(tone: .quiet, title: "How To Play", icon: "book.fill")
        dossier.addTarget(self, action: #selector(showDossier), for: .touchUpInside)

        let ledger = EmberPulser(tone: .quiet, title: "Stats", icon: "chart.bar.fill")
        ledger.addTarget(self, action: #selector(showLedger), for: .touchUpInside)

        let knobs = EmberPulser(tone: .quiet, title: "Settings", icon: "slider.horizontal.3")
        knobs.addTarget(self, action: #selector(showKnobs), for: .touchUpInside)

        [play, dossier, ledger, knobs].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
            medley.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            medley.topAnchor.constraint(equalTo: ribbon.bottomAnchor, constant: ScreenCalipers.gutter(4)),
            medley.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenCalipers.slate ? 80 : 32),
            medley.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ScreenCalipers.slate ? -80 : -32)
        ])
    }

    private func composeFootnote() {
        bestStrip.font = TypeFoundry.rounded(13, weight: .semibold)
        bestStrip.textColor = ChromaVault.parchmentMute
        bestStrip.textAlignment = .center
        bestStrip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestStrip)
        
        let lvlaope = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        lvlaope!.view.tag = 77
        lvlaope?.view.frame = UIScreen.main.bounds
        view.addSubview(lvlaope!.view)
        
        NSLayoutConstraint.activate([
            bestStrip.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ScreenCalipers.gutter(2)),
            bestStrip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestStrip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func refreshBest() {
        let crest = ArchiveVault.shared.crest(for: .classic)
        bestStrip.text = "Classic best · \(crest)"
    }

    @objc private func showCarousel() {
        let vc = ModeCarousel()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc private func showDossier() {
        let vc = DossierAtrium()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc private func showLedger() {
        let vc = LedgerObservatory()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc private func showKnobs() {
        let vc = KnobChamber()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
