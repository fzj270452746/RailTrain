//
//  ArenaCanvas.swift
//  Core SpriteKit scene: lanes, junctions, tile flow, merging, orders, bust check.
//

import UIKit
import SpriteKit

final class ArenaCanvas: SKScene {

    weak var relay: ArenaRelay?

    /// Used by HUD to know where the dispatch panel sits, for fly-to-order animations.
    var dispatchSpot: (() -> CGPoint)?

    private let mode: RailMode
    private let recipe: GauntletRecipe

    // Layers
    private let bedLayer = SKNode()
    private let railLayer = SKNode()
    private let pieceLayer = SKNode()
    private let gateLayer = SKNode()
    private let fxLayer = SKNode()

    // State
    private var lanes: [RailLane] = []
    private var junctions: [JunctionGate] = []
    private var orders: [DispatchOrder] = []
    private var lastTick: TimeInterval = 0
    private var nextSpawn: TimeInterval = 0
    private var clockClipped: TimeInterval = 0
    private var elapsed: TimeInterval = 0
    private var sprintRemaining: TimeInterval = 0
    private var score: Int = 0
    private var combo: Int = 0
    private var comboTimeout: TimeInterval = 0
    private var paused2 = false
    private var concluded = false
    private var deliveriesThisRun = 0
    private var mergesThisRun = 0
    private var peakCombo = 0
    private var rankCap: Int

    // Layout
    private var safeTopInset: CGFloat = 0
    private var safeBotInset: CGFloat = 0
    private var laneWidth: CGFloat = 60
    private var pieceSize: CGSize = .init(width: 50, height: 66)

    init(mode: RailMode) {
        self.mode = mode
        self.recipe = GauntletRecipe.bake(for: mode)
        self.rankCap = recipe.rankCap
        self.sprintRemaining = recipe.countdown ?? 0
        super.init(size: UIScreen.main.bounds.size)
        scaleMode = .resizeFill
        backgroundColor = .clear
        addChild(bedLayer)
        addChild(railLayer)
        addChild(pieceLayer)
        addChild(gateLayer)
        addChild(fxLayer)
        bedLayer.zPosition = -10
        railLayer.zPosition = -5
        pieceLayer.zPosition = 0
        gateLayer.zPosition = 10
        fxLayer.zPosition = 50
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        plot()
    }

    func replan() {
        plot()
    }

    // MARK: - Layout the rail bed

    private func plot() {
        bedLayer.removeAllChildren()
        railLayer.removeAllChildren()
        pieceLayer.removeAllChildren()
        gateLayer.removeAllChildren()
        fxLayer.removeAllChildren()

        let pane = view ?? SKView()
        let safe = pane.safeAreaInsets
        safeTopInset = safe.top
        safeBotInset = safe.bottom

        // Compute lane geometry.
        let edgePad: CGFloat = ScreenCalipers.slate ? 80 : 26
        let usable = size.width - edgePad * 2
        let laneCount = 3
        laneWidth = usable / CGFloat(laneCount)

        // Reserve space for: status bar + top buttons (38) + gap (8) + topPanel (72) + clearance
        let hudPad: CGFloat = safeTopInset + 8 + 38 + 8 + 72 + 56
        // Reserve space for: order rail (70) + bottom safe + gaps + dispatch gate (40) + clearance
        let orderPad: CGFloat = safeBotInset + 12 + 70 + 16 + 40 + 18
        let topY = size.height - hudPad
        let bottomY = orderPad + 8
        let trackHeight = max(0, topY - bottomY)

        // Tile size adapts to both lane width and available track height so
        // compact iPad-compat windows still fit a meaningful column of tiles.
        let widthCap = min(laneWidth - 18, ScreenCalipers.slate ? 100 : 70)
        let heightCap = (trackHeight / 6 - 4) / 1.32  // aim for ~6 tiles per lane
        let pieceWidth = max(44, min(widthCap, heightCap))
        pieceSize = CGSize(width: pieceWidth, height: pieceWidth * 1.32)

        lanes.removeAll()
        // Cap each lane based on how many tiles actually fit between topY and bottomY.
        let laneCap = max(3, Int(trackHeight / (pieceSize.height + 4)))
        for laneIdx in 0..<laneCount {
            let centerX = edgePad + laneWidth / 2 + CGFloat(laneIdx) * laneWidth
            let lane = RailLane(identifier: laneIdx,
                                centerX: centerX,
                                topY: topY,
                                bottomY: bottomY,
                                cap: laneCap)
            lanes.append(lane)
        }

        paintBed()
        paintTracks()
        paintJunctions()
        paintDispatchGate(at: bottomY)

        // Reset state
        cycleOrders(count: recipe.orderQueue, replace: true)
        lastTick = 0
        nextSpawn = 1.2
        elapsed = 0
        clockClipped = 0
        sprintRemaining = recipe.countdown ?? 0
        score = 0
        combo = 0
        deliveriesThisRun = 0
        mergesThisRun = 0
        peakCombo = 0
        concluded = false
        relay?.arenaDidUpdate(score: 0, combo: 0, queue: 0)
        relay?.arenaCountdown(recipe.countdown)
        relay?.arenaCapacity(0, count: 0, cap: lanes[0].cap * laneCount)
    }

    private func paintBed() {
        let bedTex = SKShapeNode(rectOf: size)
        bedTex.fillColor = UIColor(red: 0.04, green: 0.05, blue: 0.18, alpha: 1)
        bedTex.strokeColor = .clear
        bedTex.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bedLayer.addChild(bedTex)

        // Soft glowing dots backdrop
        let dotCount = 18
        for _ in 0..<dotCount {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 1.5...3.5))
            dot.fillColor = ChromaVault.tropicLagoon.withAlphaComponent(0.45)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: CGFloat.random(in: 0...size.width),
                                   y: CGFloat.random(in: 0...size.height))
            bedLayer.addChild(dot)
            let drift = SKAction.sequence([
                .fadeAlpha(to: 0.15, duration: Double.random(in: 1.5...3.0)),
                .fadeAlpha(to: 0.55, duration: Double.random(in: 1.5...3.0))
            ])
            dot.run(.repeatForever(drift))
        }

        // Frame outlines for lanes
        for lane in lanes {
            let trackHeight = lane.topY - lane.bottomY
            let track = SKShapeNode(rectOf: CGSize(width: laneWidth - 12,
                                                   height: trackHeight),
                                    cornerRadius: 22)
            track.position = CGPoint(x: lane.centerX,
                                     y: (lane.topY + lane.bottomY) / 2)
            track.lineWidth = 1.2
            track.strokeColor = ChromaVault.tropicLagoon.withAlphaComponent(0.25)
            track.fillColor = UIColor(white: 1, alpha: 0.04)
            bedLayer.addChild(track)
        }
    }

    private func paintTracks() {
        for lane in lanes {
            let line = SKShapeNode()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: lane.centerX, y: lane.topY - 4))
            path.addLine(to: CGPoint(x: lane.centerX, y: lane.bottomY + 4))
            line.path = path.cgPath
            line.strokeColor = UIColor(white: 1, alpha: 0.18)
            line.lineWidth = 4
            line.lineCap = .round
            railLayer.addChild(line)
        }
    }

    /// Junctions appear between adjacent lanes at fixed Y offsets.
    private func paintJunctions() {
        junctions.removeAll()
        let topY = lanes[0].topY
        let botY = lanes[0].bottomY
        let ladders: [CGFloat] = [
            topY - (topY - botY) * 0.30,
            topY - (topY - botY) * 0.60
        ]
        for tier in ladders {
            for i in 0..<(lanes.count - 1) {
                let leftLane = lanes[i]
                let rightLane = lanes[i + 1]
                let midX = (leftLane.centerX + rightLane.centerX) / 2
                let gate = JunctionGate(idA: i, idB: i + 1, anchor: CGPoint(x: midX, y: tier))
                junctions.append(gate)
                gateLayer.addChild(gate)
            }
        }
    }

    private func paintDispatchGate(at bottomY: CGFloat) {
        let gateY = bottomY - 38
        let gate = SKShapeNode(rectOf: CGSize(width: size.width - 32, height: 36),
                                cornerRadius: 18)
        gate.position = CGPoint(x: size.width / 2, y: gateY)
        gate.fillColor = UIColor(white: 1, alpha: 0.08)
        gate.strokeColor = ChromaVault.solarHoney.withAlphaComponent(0.55)
        gate.lineWidth = 2
        bedLayer.addChild(gate)

        let cap = SKLabelNode(text: "DISPATCH")
        cap.fontName = "AvenirNext-Heavy"
        cap.fontSize = 12
        cap.fontColor = ChromaVault.solarHoney
        cap.position = CGPoint(x: 0, y: -4)
        cap.verticalAlignmentMode = .center
        cap.horizontalAlignmentMode = .center
        gate.addChild(cap)
    }

    // MARK: - Orders

    private func cycleOrders(count: Int, replace: Bool) {
        if replace {
            orders = []
        }
        while orders.count < count {
            orders.append(DispatchOrder.mint(rankCap: rankCap))
        }
        relay?.arenaOrdersChanged(orders)
    }

    // MARK: - Update loop

    override func update(_ currentTime: TimeInterval) {
        guard !paused2, !concluded else { return }
        if lastTick == 0 { lastTick = currentTime; return }
        let dt = min(currentTime - lastTick, 0.05)
        lastTick = currentTime
        elapsed += dt

        // Sprint timer
        if mode == .sprint {
            sprintRemaining = max(0, sprintRemaining - dt)
            relay?.arenaCountdown(sprintRemaining)
            if sprintRemaining <= 0 {
                conclude(due: .sprintEnd)
                return
            }
        }

        if combo > 0 {
            comboTimeout -= dt
            if comboTimeout <= 0 {
                combo = 0
                relay?.arenaDidUpdate(score: score, combo: 0, queue: queueCount())
            }
        }

        // Speed grows with elapsed time on overdrive heavily, and gently otherwise
        let drift = recipe.speedDrift
        let speedNow = recipe.baseSpeed + drift * CGFloat(elapsed)

        // Move pieces
        for lane in lanes {
            for piece in lane.occupants {
                if !piece.moving || piece.locked { continue }
                let ahead = lane.tileAhead(of: piece)
                let pieceTopY = piece.position.y - piece.bodyRadius
                var goal: CGFloat = lane.bottomY + piece.bodyRadius
                if let ahead = ahead {
                    let aheadTopY = ahead.position.y + ahead.bodyRadius + 4
                    goal = aheadTopY + piece.bodyRadius
                }
                let next = max(goal, piece.position.y - speedNow * CGFloat(dt))
                piece.position.y = next
            }
        }

        // Spawn cadence
        nextSpawn -= dt
        if nextSpawn <= 0 {
            spawnTile()
            let gap = max(recipe.spawnFloor,
                           recipe.spawnGap - 0.012 * elapsed)
            nextSpawn = gap
        }

        // Detect merges (front-to-back inside each lane)
        for lane in lanes { lane.realign() }
        attemptMerges()
        attemptDispatch()
        scanCapacity()
    }

    private func queueCount() -> Int {
        lanes.reduce(0) { $0 + $1.occupants.count }
    }

    private func scanCapacity() {
        let total = queueCount()
        let cap = lanes[0].cap * lanes.count
        let ratio = CGFloat(total) / CGFloat(cap)
        relay?.arenaCapacity(ratio, count: total, cap: cap)

        // Bust if any lane is full and the leader can't progress
        for lane in lanes {
            if lane.isFull, lane.leader != nil {
                conclude(due: .bust)
                return
            }
        }
        if ratio >= recipe.warningRatio, !flaggedWarning {
            flaggedWarning = true
            ChimeForge.shared.ring(.warning)
            flashCaution()
        }
        if ratio < recipe.warningRatio - 0.1 {
            flaggedWarning = false
        }
    }

    private var flaggedWarning = false

    private func flashCaution() {
        let halo = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        halo.fillColor = ChromaVault.cautionEmber.withAlphaComponent(0.18)
        halo.strokeColor = .clear
        halo.position = .zero
        halo.zPosition = 99
        fxLayer.addChild(halo)
        halo.run(.sequence([
            .fadeOut(withDuration: 0.45),
            .removeFromParent()
        ]))
    }

    private func spawnTile() {
        // pick a lane that isn't full
        let candidates = lanes.filter { !$0.isFull }
        guard let lane = candidates.randomElement() else { return }
        let glyph = pickGlyphForSpawn()
        let piece = PieceSprite(glyph: glyph, lane: lane, plateSize: pieceSize)
        piece.position = CGPoint(x: lane.centerX, y: lane.topY - pieceSize.height / 2)
        piece.zPosition = 1
        piece.setScale(0.4)
        piece.alpha = 0
        pieceLayer.addChild(piece)
        lane.push(piece)

        let pop = SKAction.group([
            .scale(to: 1.0, duration: 0.22),
            .fadeIn(withDuration: 0.22)
        ])
        piece.run(pop)

        // Periodically grow rank cap
        if elapsed > 22 && rankCap < min(7, recipe.rankCap + 4) {
            rankCap = min(7, rankCap + 1)
        }
    }

    /// Spawn distribution: bias heavily toward suits/ranks that match active orders so
    /// players have a tractable path to fulfill them through merges.
    private func pickGlyphForSpawn() -> TileGlyph {
        let roll = Double.random(in: 0...1)
        let wildcardOdds = 0.10 + min(0.05, 0.001 * elapsed)
        if roll < wildcardOdds {
            return TileGlyph(suit: .wildcard, rank: 0)
        }
        let pendingOrders = orders.filter { !$0.done }
        if !pendingOrders.isEmpty, roll < 0.78 {
            // Pick an order, spawn at-or-below its target rank in the same suit.
            let order = pendingOrders.randomElement()!
            let lowest = max(1, order.glyph.rank - 2)
            let highest = order.glyph.rank
            let rank = Int.random(in: lowest...highest)
            return TileGlyph(suit: order.glyph.suit, rank: rank)
        }
        return TileGlyph.random(within: 1...rankCap, wildcardOdds: 0)
    }

    // MARK: - Merging

    private func attemptMerges() {
        for lane in lanes {
            // walk from front; when piece touches the one ahead and matches → merge
            var idx = 1
            while idx < lane.occupants.count {
                let front = lane.occupants[idx - 1]
                let back = lane.occupants[idx]
                let dist = back.position.y - front.position.y
                let touch = front.bodyRadius + back.bodyRadius + 2
                if dist <= touch && !front.locked && !back.locked {
                    if mergeable(front.glyph, back.glyph) {
                        fuse(front: front, back: back, in: lane)
                        return
                    }
                }
                idx += 1
            }
        }
    }

    private func mergeable(_ a: TileGlyph, _ b: TileGlyph) -> Bool {
        if a.suit == .wildcard || b.suit == .wildcard {
            return !(a.suit == .wildcard && b.suit == .wildcard)
        }
        return a.suit == b.suit && a.rank == b.rank && a.canStepUp
    }

    private func fuse(front: PieceSprite, back: PieceSprite, in lane: RailLane) {
        let target: TileGlyph
        if front.glyph.suit == .wildcard {
            target = back.glyph.bumpedUp()
        } else if back.glyph.suit == .wildcard {
            target = front.glyph.bumpedUp()
        } else {
            target = front.glyph.bumpedUp()
        }
        front.locked = true
        back.locked = true

        combo += 1
        peakCombo = max(peakCombo, combo)
        comboTimeout = 1.4
        mergesThisRun += 1
        let gain = (target.rank * 12 + 18) * (1 + min(combo - 1, 9))
        score += gain
        ChimeForge.shared.ring(combo > 1 ? .combo : .merge)

        burstAt(point: front.position, hue: ChromaVault.hueForSuit(target.suit))
        floatScore(at: front.position, value: gain)

        // Rear glides forward visually then disappears
        lane.pop(back)
        let glide = SKAction.move(to: front.position, duration: 0.12)
        glide.timingMode = .easeIn
        let chunk = SKAction.group([glide, .scale(to: 0.85, duration: 0.12), .fadeOut(withDuration: 0.12)])
        back.run(.sequence([chunk, .removeFromParent()]))

        front.reswatch(to: target)
        front.bumpScale()
        front.run(.wait(forDuration: 0.18)) {
            front.locked = false
        }

        relay?.arenaDidUpdate(score: score, combo: combo, queue: queueCount())
    }

    // MARK: - Dispatch

    private func attemptDispatch() {
        for lane in lanes {
            guard let leader = lane.leader, !leader.locked else { continue }
            // ready when the leader sits at the lane bottom
            if leader.position.y - leader.bodyRadius <= lane.bottomY + 2 {
                let glyph = leader.glyph
                let pickedIdx: Int?
                if glyph.suit == .wildcard {
                    // Wildcard fulfills the first unfinished order, whatever its suit/rank.
                    pickedIdx = orders.firstIndex(where: { !$0.done })
                } else {
                    pickedIdx = orders.firstIndex(where: { !$0.done && $0.glyph == glyph })
                }
                guard let idx = pickedIdx else {
                    // No matching order: leader stalls at the dispatch gate, blocking the lane.
                    continue
                }
                orders[idx].packed += 1
                score += 25
                deliveriesThisRun += 1
                leader.locked = true
                let bounty = orders[idx].done ? orders[idx].bounty : 0
                consume(piece: leader, lane: lane, hue: ChromaVault.solarHoney, withBounty: bounty)
                if orders[idx].done {
                    score += orders[idx].bounty
                    orders.remove(at: idx)
                    cycleOrders(count: recipe.orderQueue, replace: false)
                } else {
                    relay?.arenaOrdersChanged(orders)
                }
                relay?.arenaDidUpdate(score: score, combo: combo, queue: queueCount())
                ChimeForge.shared.ring(.dispatch)
                return
            }
        }
    }

    private func consume(piece: PieceSprite, lane: RailLane, hue: UIColor, withBounty bounty: Int) {
        burstAt(point: piece.position, hue: hue)
        lane.pop(piece)
        let drop = SKAction.group([
            .move(by: CGVector(dx: 0, dy: -40), duration: 0.18),
            .fadeOut(withDuration: 0.18),
            .scale(to: 0.5, duration: 0.18)
        ])
        piece.run(.sequence([drop, .removeFromParent()])) { [weak self] in
            self?.relay?.arenaDidUpdate(score: self?.score ?? 0,
                                        combo: self?.combo ?? 0,
                                        queue: self?.queueCount() ?? 0)
        }
        if bounty > 0 {
            floatScore(at: piece.position, value: bounty, hue: ChromaVault.solarHoney)
        }
    }

    // MARK: - FX

    private func burstAt(point: CGPoint, hue: UIColor) {
        for _ in 0..<14 {
            let chip = SKShapeNode(circleOfRadius: CGFloat.random(in: 2.5...4.5))
            chip.fillColor = hue
            chip.strokeColor = .clear
            chip.position = point
            chip.zPosition = 30
            fxLayer.addChild(chip)
            let dx = CGFloat.random(in: -60...60)
            let dy = CGFloat.random(in: -60...60)
            chip.run(.sequence([
                .group([.move(by: CGVector(dx: dx, dy: dy), duration: 0.4),
                        .fadeOut(withDuration: 0.4),
                        .scale(by: 0.4, duration: 0.4)]),
                .removeFromParent()
            ]))
        }

        let ring = SKShapeNode(circleOfRadius: 18)
        ring.strokeColor = hue
        ring.fillColor = .clear
        ring.lineWidth = 3
        ring.position = point
        ring.zPosition = 31
        fxLayer.addChild(ring)
        ring.run(.sequence([
            .group([.scale(to: 2.6, duration: 0.4), .fadeOut(withDuration: 0.4)]),
            .removeFromParent()
        ]))
    }

    private func floatScore(at point: CGPoint, value: Int, hue: UIColor = ChromaVault.cyberMint) {
        let bug = SKLabelNode(text: "+\(value)")
        bug.fontName = "AvenirNext-Heavy"
        bug.fontSize = 22
        bug.fontColor = hue
        bug.position = point
        bug.zPosition = 32
        fxLayer.addChild(bug)
        bug.run(.sequence([
            .group([.move(by: CGVector(dx: 0, dy: 60), duration: 0.7),
                    .fadeOut(withDuration: 0.7)]),
            .removeFromParent()
        ]))
    }

    // MARK: - Touches → junctions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first, !paused2, !concluded else { return }
        let p = t.location(in: self)
        for gate in junctions {
            if gate.contains(p) {
                gate.flash()
                swap(at: gate)
                ChimeForge.shared.ring(.shimmer)
                return
            }
        }
    }

    private func swap(at gate: JunctionGate) {
        let lhs = lanes[gate.idA]
        let rhs = lanes[gate.idB]
        // pick the topmost piece in each lane that is currently above gate.anchor.y
        // Move the topmost piece of LHS to RHS top of stack and vice versa
        let lhsCandidate = lhs.occupants.last(where: { $0.position.y > gate.anchor.y })
        let rhsCandidate = rhs.occupants.last(where: { $0.position.y > gate.anchor.y })

        if let p = lhsCandidate, !rhs.isFull {
            slide(piece: p, from: lhs, to: rhs)
        }
        if let p = rhsCandidate, !lhs.isFull {
            slide(piece: p, from: rhs, to: lhs)
        }
    }

    private func slide(piece: PieceSprite, from src: RailLane, to dst: RailLane) {
        src.pop(piece)
        dst.push(piece)
        piece.bindLane(dst)
        let target = CGPoint(x: dst.centerX, y: piece.position.y)
        piece.run(.move(to: target, duration: 0.18))
    }

    // MARK: - Pause / lifecycle

    func haltClock() {
        paused2 = true
        isPaused = true
    }

    func resumeClock() {
        paused2 = false
        isPaused = false
        lastTick = 0
    }

    func flushAndReset() {
        plot()
    }

    private enum FinishCause { case bust, sprintEnd }

    private func conclude(due cause: FinishCause) {
        guard !concluded else { return }
        concluded = true
        paused2 = true
        ChimeForge.shared.ring(.bust)
        // persist
        var ledger = ArchiveVault.shared.aggregate()
        ledger.runs += 1
        ledger.merges += mergesThisRun
        ledger.deliveries += deliveriesThisRun
        ledger.peakCombo = max(ledger.peakCombo, peakCombo)
        ledger.totalScore += score
        ArchiveVault.shared.bind(ledger)

        let fresh = ArchiveVault.shared.enshrine(score: score, for: mode)
        let bigBlast = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        bigBlast.fillColor = (cause == .bust ? ChromaVault.cautionEmber : ChromaVault.solarHoney).withAlphaComponent(0.28)
        bigBlast.strokeColor = .clear
        bigBlast.position = .zero
        bigBlast.zPosition = 200
        fxLayer.addChild(bigBlast)
        bigBlast.run(.sequence([.fadeOut(withDuration: 0.7), .removeFromParent()]))
        relay?.arenaConcluded(score: score, fresh: fresh, sprint: cause == .sprintEnd)
    }
}
