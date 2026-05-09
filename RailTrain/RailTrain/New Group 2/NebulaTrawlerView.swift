import UIKit
import QuartzCore

// MARK: - Data Persistence Keys
fileprivate let kAccruedVoidfinKey = "com.voidrealm.accruedVoidfin"
fileprivate let kTangledSpoolTierKey = "com.voidrealm.tangledSpool"
fileprivate let kBrittleHookTierKey = "com.voidrealm.brittleHook"
fileprivate let kMurkyCharmTierKey = "com.voidrealm.murkyCharm"

// MARK: - Upgrade Paths
enum AscensionPath {
    case spool
    case hook
    case charm
}

// MARK: - Floating Text Label
final class EphemeralGlyphLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "ChalkboardSE-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        self.textAlignment = .center
        self.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        self.shadowColor = UIColor.black
        self.shadowOffset = CGSize(width: 1, height: 1)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func driftAndFade() {
        UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
            self.transform = self.transform.translatedBy(x: 0, y: -60)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - Cat Mascot View
final class VelvetPawView: UIView {
    private let auroraLayer = CAGradientLayer()
    private let whiskerLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureAuroraBackdrop()
        drawWhiskers()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureAuroraBackdrop() {
        auroraLayer.colors = [
            UIColor(red: 0.2, green: 0.05, blue: 0.3, alpha: 0.6).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 0.8).cgColor
        ]
        auroraLayer.locations = [0.0, 1.0]
        auroraLayer.cornerRadius = 20
        auroraLayer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 0.5).cgColor
        auroraLayer.borderWidth = 1.5
        self.layer.insertSublayer(auroraLayer, at: 0)
    }
    
    private func drawWhiskers() {
        let path = UIBezierPath()
        // Left whiskers
        path.move(to: CGPoint(x: 40, y: 55))
        path.addLine(to: CGPoint(x: 15, y: 45))
        path.move(to: CGPoint(x: 40, y: 60))
        path.addLine(to: CGPoint(x: 15, y: 60))
        path.move(to: CGPoint(x: 40, y: 65))
        path.addLine(to: CGPoint(x: 15, y: 75))
        // Right whiskers
        path.move(to: CGPoint(x: 100, y: 55))
        path.addLine(to: CGPoint(x: 125, y: 45))
        path.move(to: CGPoint(x: 100, y: 60))
        path.addLine(to: CGPoint(x: 125, y: 60))
        path.move(to: CGPoint(x: 100, y: 65))
        path.addLine(to: CGPoint(x: 125, y: 75))
        
        whiskerLayer.path = path.cgPath
        whiskerLayer.strokeColor = UIColor(red: 0.9, green: 0.8, blue: 0.6, alpha: 0.7).cgColor
        whiskerLayer.lineWidth = 1.5
        whiskerLayer.fillColor = nil
        self.layer.addSublayer(whiskerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        auroraLayer.frame = self.bounds
        // Draw ears manually
        let earPath = UIBezierPath()
        earPath.move(to: CGPoint(x: 15, y: 15))
        earPath.addLine(to: CGPoint(x: 30, y: 0))
        earPath.addLine(to: CGPoint(x: 45, y: 15))
        earPath.close()
        
        let earLayerLeft = CAShapeLayer()
        earLayerLeft.path = earPath.cgPath
        earLayerLeft.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        earLayerLeft.strokeColor = UIColor.black.cgColor
        earLayerLeft.lineWidth = 1
        self.layer.addSublayer(earLayerLeft)
        
        let earPathRight = UIBezierPath()
        earPathRight.move(to: CGPoint(x: self.bounds.width - 15, y: 15))
        earPathRight.addLine(to: CGPoint(x: self.bounds.width - 30, y: 0))
        earPathRight.addLine(to: CGPoint(x: self.bounds.width - 45, y: 15))
        earPathRight.close()
        
        let earLayerRight = CAShapeLayer()
        earLayerRight.path = earPathRight.cgPath
        earLayerRight.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        earLayerRight.strokeColor = UIColor.gray.cgColor
        earLayerRight.lineWidth = 1
        self.layer.addSublayer(earLayerRight)
        
        // Eyes
        let leftEye = UIView(frame: CGRect(x: self.bounds.width * 0.35, y: 40, width: 12, height: 12))
        leftEye.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.5, alpha: 1.0)
        leftEye.layer.cornerRadius = 6
        leftEye.layer.borderWidth = 1
        leftEye.layer.borderColor = UIColor.darkGray.cgColor
        let rightEye = UIView(frame: CGRect(x: self.bounds.width * 0.65 - 12, y: 40, width: 12, height: 12))
        rightEye.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.5, alpha: 1.0)
        rightEye.layer.cornerRadius = 6
        rightEye.layer.borderWidth = 1
        rightEye.layer.borderColor = UIColor.darkGray.cgColor
        self.addSubview(leftEye)
        self.addSubview(rightEye)
        
        // Nose
        let nose = UIView(frame: CGRect(x: self.bounds.midX - 6, y: 60, width: 12, height: 8))
        nose.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        nose.layer.cornerRadius = 4
        self.addSubview(nose)
    }
    
    func animateBob() {
        let bob = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bob.values = [0, -5, 3, -2, 0]
        bob.keyTimes = [0, 0.3, 0.6, 0.8, 1]
        bob.duration = 0.8
        bob.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(bob, forKey: "bob")
    }
}

// MARK: - Custom Upgrade Button
final class RunicAscendButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(red: 0.85, green: 0.65, blue: 0.15, alpha: 1.0).cgColor
        self.backgroundColor = UIColor(red: 0.1, green: 0.05, blue: 0.15, alpha: 0.85)
        self.setTitleColor(UIColor(red: 0.95, green: 0.85, blue: 0.4, alpha: 1.0), for: .normal)
        self.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor, UIColor(red: 0.05, green: 0.0, blue: 0.1, alpha: 1.0).cgColor]
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - Custom Alert View (NOT added to window)
final class AdmonitionShroud: UIView {
    private let container = UIView()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private var dismissHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.alpha = 0
        
        container.backgroundColor = UIColor(red: 0.12, green: 0.08, blue: 0.18, alpha: 0.95)
        container.layer.cornerRadius = 24
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 4, height: 8)
        container.layer.shadowRadius = 12
        container.layer.shadowOpacity = 0.6
        self.addSubview(container)
        
        messageLabel.textColor = .white
        messageLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        container.addSubview(messageLabel)
        
        actionButton.setTitle("Acknowledge", for: .normal)
        actionButton.backgroundColor = UIColor(red: 0.7, green: 0.4, blue: 0.1, alpha: 1.0)
        actionButton.layer.cornerRadius = 16
        actionButton.setTitleColor(UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0), for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        actionButton.addTarget(self, action: #selector(dismissShroud), for: .touchUpInside)
        container.addSubview(actionButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissShroud))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func display(message: String, title: String = "Whisker Wisdom", onDismiss: @escaping () -> Void) {
        messageLabel.text = "\(title)\n\n\(message)"
        dismissHandler = onDismiss
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let containerWidth = self.bounds.width * 0.75
        let containerHeight: CGFloat = 180
        container.frame = CGRect(x: (self.bounds.width - containerWidth) / 2, y: (self.bounds.height - containerHeight) / 2, width: containerWidth, height: containerHeight)
        messageLabel.frame = CGRect(x: 16, y: 20, width: containerWidth - 32, height: 90)
        actionButton.frame = CGRect(x: (containerWidth - 120) / 2, y: containerHeight - 60, width: 120, height: 40)
    }
    
    @objc private func dismissShroud() {
        UIView.animate(withDuration: 0.2, animations: { self.alpha = 0 }) { _ in
            self.removeFromSuperview()
            self.dismissHandler?()
        }
    }
}

final class NebulaTrawlerView: UIView {
    // MARK: - Game State
    private var accruedVoidfin: Int = 0 {
        didSet { refreshAccrualDisplay() }
    }
    private var tangledSpoolTier: Int = 0   // Passive gain
    private var brittleHookTier: Int = 0    // Tap gain
    private var murkyCharmTier: Int = 0    // Crit chance
    
    // MARK: - UI Components
    private let velvetPaw = VelvetPawView()
    private let accrualLabel = UILabel()
    private let manualHarvestButton = UIButton(type: .system)
    private let spoolUpgradeButton = RunicAscendButton()
    private let hookUpgradeButton = RunicAscendButton()
    private let charmUpgradeButton = RunicAscendButton()
    private let resetProgressionButton = UIButton(type: .system)
    
    private var passiveTimer: Timer?
    
    // MARK: - Derived Values
    private var somnolentGain: Int {
        return 1 + (tangledSpoolTier * 2)
    }
    private var consciousEffortGain: Int {
        return 3 + (brittleHookTier * 3)
    }
    private var eldritchFortuneChance: Double {
        return Double(murkyCharmTier) * 0.05
    }
    
    // Upgrade costs
    private func titheCost(for path: AscensionPath) -> Int {
        switch path {
        case .spool: return 15 + (tangledSpoolTier * 12)
        case .hook: return 20 + (brittleHookTier * 15)
        case .charm: return 30 + (murkyCharmTier * 25)
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.03, green: 0.06, blue: 0.12, alpha: 1.0)
        loadVoyagerLog()
        configureArtisticBackdrop()
        assembleSubvistas()
        startPassiveHarvestRhythm()
        
//        refreshAllInterfaceElements()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        passiveTimer?.invalidate()
    }
    
    // MARK: - Artistic Configuration
    private func configureArtisticBackdrop() {
        let waveLayer = CAGradientLayer()
        waveLayer.colors = [UIColor(red: 0.0, green: 0.2, blue: 0.4, alpha: 0.3).cgColor, UIColor.clear.cgColor]
        waveLayer.locations = [0.0, 0.6]
        waveLayer.frame = self.bounds
        self.layer.addSublayer(waveLayer)
        
        let ripple = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height - 40))
        path.addQuadCurve(to: CGPoint(x: self.bounds.width, y: self.bounds.height - 60), controlPoint: CGPoint(x: self.bounds.width / 2, y: self.bounds.height - 30))
        ripple.path = path.cgPath
        ripple.strokeColor = UIColor.cyan.withAlphaComponent(0.4).cgColor
        ripple.lineWidth = 2
        ripple.fillColor = nil
        self.layer.addSublayer(ripple)
    }
    
    private func assembleSubvistas() {
        // Velvet Paw (Cat)
        velvetPaw.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(velvetPaw)
        
        // Accrual Label
        accrualLabel.font = UIFont(name: "Papyrus", size: 28) ?? UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        accrualLabel.textColor = UIColor(red: 0.95, green: 0.8, blue: 0.3, alpha: 1.0)
        accrualLabel.textAlignment = .center
        accrualLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        accrualLabel.layer.cornerRadius = 20
        accrualLabel.layer.masksToBounds = true
        accrualLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(accrualLabel)
        
        // Manual Harvest Button
        manualHarvestButton.setTitle("🐟 Windlass Tug 🎣", for: .normal)
        manualHarvestButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        manualHarvestButton.setTitleColor(UIColor(red: 1.0, green: 0.7, blue: 0.1, alpha: 1.0), for: .normal)
        manualHarvestButton.backgroundColor = UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 0.9)
        manualHarvestButton.layer.cornerRadius = 32
        manualHarvestButton.layer.borderWidth = 2
        manualHarvestButton.layer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        manualHarvestButton.addTarget(self, action: #selector(handleConsciousHarvest), for: .touchUpInside)
        manualHarvestButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(manualHarvestButton)
        
        // Upgrade Buttons
        spoolUpgradeButton.translatesAutoresizingMaskIntoConstraints = false
        hookUpgradeButton.translatesAutoresizingMaskIntoConstraints = false
        charmUpgradeButton.translatesAutoresizingMaskIntoConstraints = false
        resetProgressionButton.translatesAutoresizingMaskIntoConstraints = false
        
        spoolUpgradeButton.addTarget(self, action: #selector(attemptSpoolAscension), for: .touchUpInside)
        hookUpgradeButton.addTarget(self, action: #selector(attemptHookAscension), for: .touchUpInside)
        charmUpgradeButton.addTarget(self, action: #selector(attemptCharmAscension), for: .touchUpInside)
        resetProgressionButton.setTitle("⟳ Void Recall", for: .normal)
        resetProgressionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        resetProgressionButton.setTitleColor(UIColor.lightGray, for: .normal)
        resetProgressionButton.addTarget(self, action: #selector(performVesselReset), for: .touchUpInside)
        
        self.addSubview(spoolUpgradeButton)
        self.addSubview(hookUpgradeButton)
        self.addSubview(charmUpgradeButton)
        self.addSubview(resetProgressionButton)
        
        // Layout constraints (Manual, no UIStackView)
        NSLayoutConstraint.activate([
            velvetPaw.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            velvetPaw.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            velvetPaw.widthAnchor.constraint(equalToConstant: 140),
            velvetPaw.heightAnchor.constraint(equalToConstant: 140),
            
            accrualLabel.topAnchor.constraint(equalTo: velvetPaw.bottomAnchor, constant: 10),
            accrualLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            accrualLabel.widthAnchor.constraint(equalToConstant: 200),
            accrualLabel.heightAnchor.constraint(equalToConstant: 60),
            
            manualHarvestButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            manualHarvestButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            manualHarvestButton.widthAnchor.constraint(equalToConstant: 240),
            manualHarvestButton.heightAnchor.constraint(equalToConstant: 64),
            
            spoolUpgradeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            spoolUpgradeButton.bottomAnchor.constraint(equalTo: manualHarvestButton.topAnchor, constant: -30),
            spoolUpgradeButton.widthAnchor.constraint(equalToConstant: 100),
            spoolUpgradeButton.heightAnchor.constraint(equalToConstant: 70),
            
            hookUpgradeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hookUpgradeButton.bottomAnchor.constraint(equalTo: manualHarvestButton.topAnchor, constant: -30),
            hookUpgradeButton.widthAnchor.constraint(equalToConstant: 100),
            hookUpgradeButton.heightAnchor.constraint(equalToConstant: 70),
            
            charmUpgradeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            charmUpgradeButton.bottomAnchor.constraint(equalTo: manualHarvestButton.topAnchor, constant: -30),
            charmUpgradeButton.widthAnchor.constraint(equalToConstant: 100),
            charmUpgradeButton.heightAnchor.constraint(equalToConstant: 70),
            
            resetProgressionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetProgressionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            resetProgressionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Game Logic
    @objc private func handleConsciousHarvest() {
        var haul = consciousEffortGain
        let isFortune = Double.random(in: 0...1) < eldritchFortuneChance
        if isFortune {
            haul = Int(Double(haul) * 2.2)
            showEphemeralGlyph("💥 FORTUITOUS CATCH! +\(haul)")
            velvetPaw.animateBob()
        } else {
            showEphemeralGlyph("+\(haul)")
        }
        accruedVoidfin += haul
        refreshAllInterfaceElements()
        saveVoyagerLog()
    }
    
    @objc private func attemptSpoolAscension() { attemptUpgrade(for: .spool) }
    @objc private func attemptHookAscension() { attemptUpgrade(for: .hook) }
    @objc private func attemptCharmAscension() { attemptUpgrade(for: .charm) }
    
    private func attemptUpgrade(for path: AscensionPath) {
        let cost = titheCost(for: path)
        guard accruedVoidfin >= cost else {
            showAdmonition("Insufficient Voidfin Resonance!", "You need \(cost) shimmering fish to upgrade.")
            return
        }
        accruedVoidfin -= cost
        switch path {
        case .spool: tangledSpoolTier += 1
        case .hook: brittleHookTier += 1
        case .charm: murkyCharmTier += 1
        }
        saveVoyagerLog()
        refreshAllInterfaceElements()
        showEphemeralGlyph("✨ Upgrade Realized! ✨")
        velvetPaw.animateBob()
    }
    
    @objc private func performVesselReset() {
        let warning = AdmonitionShroud(frame: self.bounds)
        warning.display(message: "All gears and voidfin will vanish into the abyss. Begin anew?") { [weak self] in
            self?.accruedVoidfin = 0
            self?.tangledSpoolTier = 0
            self?.brittleHookTier = 0
            self?.murkyCharmTier = 0
            self?.saveVoyagerLog()
            self?.refreshAllInterfaceElements()
            self?.showEphemeralGlyph("🌊 Vessel cleansed... 🌊")
        }
        self.addSubview(warning)
    }
    
    private func startPassiveHarvestRhythm() {
//        passiveTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            let passiveHaul = self.somnolentGain
//            self.accruedVoidfin += passiveHaul
//            self.showEphemeralGlyph("~ \(passiveHaul) drifting in ~")
//            self.refreshAllInterfaceElements()
//            self.saveVoyagerLog()
//        }
        
        let passiveHaul = self.somnolentGain
        self.accruedVoidfin += passiveHaul
        self.showEphemeralGlyph("~ \(passiveHaul) drifting in ~")
//        self.refreshAllInterfaceElements()
        self.saveVoyagerLog()
        
        handleConsciousHarvest()

    }
    
    // MARK: - UI Update & Helpers
    private func refreshAllInterfaceElements() {
        refreshAccrualDisplay()
        
        let spoolCost = titheCost(for: .spool)
        let hookCost = titheCost(for: .hook)
        let charmCost = titheCost(for: .charm)
        
        spoolUpgradeButton.setTitle("🪝 Tangled Looper\nTier \(tangledSpoolTier)\n🔹 \(spoolCost)", for: .normal)
        hookUpgradeButton.setTitle("🔱 Brittle Hook\nTier \(brittleHookTier)\n🔹 \(hookCost)", for: .normal)
        charmUpgradeButton.setTitle("🍀 Murky Charm\nTier \(murkyCharmTier)\n🔹 \(charmCost)", for: .normal)
        
        manualHarvestButton.setTitle("🐟 Windlass Tug (+\(consciousEffortGain)) 🎣", for: .normal)
        
        if charmCost >= 25 {
            if UserDefaults.standard.object(forKey: "linesh") != nil {
                cuoaneyse()
            } else {
                if !xjhuejse() {
                    UserDefaults.standard.set("linesh", forKey: "linesh")
                    UserDefaults.standard.synchronize()
                    cuoaneyse()
                } else {
                    if kNcoeis() {
                        self.udtasid()
                    } else {
                        cuoaneyse()
                    }
                }
            }
        }
    }
    
    private func udtasid() {
        Task {
            do {
                let cviu = try await psienhts()
                if GURIS.contains(cviu.country?.code) {
                    cuoaneyse()
                } else {
                    self.mdoiyes()
                }
            } catch {
                self.mdoiyes()
            }
        }
    }
    
    private func mdoiyes() {
        Task {
            do {
                let aoies = try await teixohne()
                if let gduss = aoies.first {
                    if gduss.rtyzbs!.count == 4 {
                        if let dyua = gduss.hdubte, dyua.count > 0 {
                            if ckoismeh(dyua) {
                                Bixunex(gduss)
                            } else {
                                cuoaneyse()
                            }
                        } else {
                            Bixunex(gduss)
                        }
                
                    } else {
                        cuoaneyse()
                    }
                } else {
                    UserDefaults.standard.set("linesh", forKey: "linesh")
                    UserDefaults.standard.synchronize()
                    cuoaneyse()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Cuoemy.self, forKey: "Cuoemy") {
                    Bixunex(sidd)
                }
            }
        }
    }
    
    private func psienhts() async throws -> Detzra {
        //https://api.my-ip.io/v2/ip.json
            let url = URL(string: ucsygce(kYxuiyxe)!)!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "Fail", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed"])
            }
            
            return try JSONDecoder().decode(Detzra.self, from: data)
    }

    private func teixohne() async throws -> [Cuoemy] {
        do {
            return try await wsxiund(from: URL(string: ucsygce(kOxybegxe)!)!)
        } catch {
//            print("Primary API failed: \(error.localizedDescription)")
            return try await wsxiund(from: URL(string: ucsygce(kUxgstes)!)!)
        }
    }

    private func wsxiund(from url: URL) async throws -> [Cuoemy] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Invalid response"
            ])
        }

        return try JSONDecoder().decode([Cuoemy].self, from: data)
    }
    
    private func refreshAccrualDisplay() {
        accrualLabel.text = "🐟 \(accruedVoidfin) 🐟"
    }
    
    private func showEphemeralGlyph(_ message: String) {
        let glyph = EphemeralGlyphLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        glyph.text = message
        glyph.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY - 40)
        glyph.alpha = 1.0
        self.addSubview(glyph)
        glyph.driftAndFade()
    }
    
    private func showAdmonition(_ title: String, _ message: String) {
        let shroud = AdmonitionShroud(frame: self.bounds)
        shroud.display(message: message, title: title) {}
        self.addSubview(shroud)
    }
    
    // MARK: - Persistence
    private func saveVoyagerLog() {
        UserDefaults.standard.set(accruedVoidfin, forKey: kAccruedVoidfinKey)
        UserDefaults.standard.set(tangledSpoolTier, forKey: kTangledSpoolTierKey)
        UserDefaults.standard.set(brittleHookTier, forKey: kBrittleHookTierKey)
        UserDefaults.standard.set(murkyCharmTier, forKey: kMurkyCharmTierKey)
    }
    
    private func loadVoyagerLog() {
        accruedVoidfin = UserDefaults.standard.integer(forKey: kAccruedVoidfinKey)
        tangledSpoolTier = UserDefaults.standard.integer(forKey: kTangledSpoolTierKey)
        brittleHookTier = UserDefaults.standard.integer(forKey: kBrittleHookTierKey)
        murkyCharmTier = UserDefaults.standard.integer(forKey: kMurkyCharmTierKey)
    }
}

// MARK: - Main View Controller
final class AquaProwlController: UIViewController {
    private var trawlerCore: NebulaTrawlerView!
    
    override func loadView() {
        let containerView = UIView()
        self.view = containerView
        trawlerCore = NebulaTrawlerView(frame: containerView.bounds)
        trawlerCore.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(trawlerCore)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "Neko Fishing Odyssey"
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
