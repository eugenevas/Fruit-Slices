
import AVFoundation
import AVKit
import SpriteKit
import UIKit


enum ForceBomb {
    case never
    case always
    case random
}

enum SequenceType: CaseIterable {
    case oneNoBomb
    case one
    case twoWithOneBomb
    case two
    case three
    case four
    case chain
    case fastChain
}


enum GameMode {
    case history
    case endless
    case none
}

class GameScene: ParentScene {
    // MARK: -Properties
    var fruits = ["lemon.png", "watermelon.png", "purple.png", "cherry.png"]
    var headers = ["good.png", "great.png"]
    
    var gameMode: GameMode = .none
    var levelLabel: SKLabelNode!
    var level: Int = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            
            if gameMode == .history {
                switch score {
                case 5:
                    level = 2
                    winGame(trigerredByBomb: false)
                case 10:
                    level = 3
                case 20:
                    level = 4
                case 30:
                    level = 5
                case 40:
                    level = 6
                case 50:
                    level = 7
                case 70:
                    level = 8
                case 90:
                    level = 9
                case 100:
                    level = 10
                    winGame(trigerredByBomb: false)
                    
                default:
                    break
                }
                
                switch level {
                case 2:
                    createGood()
                    if gameSetting.isSound {
                        self.run(SKAction.playSoundFileNamed("bonus", waitForCompletion: false))
                    }
                case 3:
                    createGood()
                case 5:
                    createGood()
                case 7:
                    createGood()
                case 10:
                    createGood()
                default:
                    break
                }
            }
            
            
            gameScore.text = "Score: \(score)"
        }
    }
    
    fileprivate let gameSetting = GameSettings()
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    // MARK: -Slash Mechanic
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    
    var isSwooshSoundActive = false
    var activeEnemies = [SKSpriteNode]()
    var bombSFX: AVAudioPlayer?
    
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    
    var isGameEnded = false
    
    
    // MARK: -Game Init
    override func didMove(to view: SKView) {
        
        self.scene?.isPaused = false
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
        
        initScene()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 1000 {
            let nextSequence = SequenceType.allCases.randomElement()!
            sequence.append(nextSequence)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.tossEnemies()
        }
        
        
        if gameMode == .endless {
//            if score == 3 {
//                winGame(trigerredByBomb: false)
//            }
            levelLabel.alpha = 0
        }
        
        
    }
    
    
    
    // MARK: -Game Update
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -50 {
                    node.removeFromParent()
                    //                    activeEnemies.remove(at: index)
                    //                    node.removeAllActions()
                    
                    if node.name == "fruit" {
                        node.name = ""                        //очистить имя
                        subtractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                        
//                    } else if node.name == "bonus" {
//                        node.name = ""
//                        node.removeFromParent()
//                        activeEnemies.remove(at: index)
                    }
                    
                    else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) {
                    [unowned self] in self.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs - stop the fuse sound
            bombSFX?.stop()
            bombSFX = nil
        }
    }
    
}


// MARK: -Touch Input
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
        
        // MARK: -Уничтожение бонуса
        //        if activeSlicePoints.count > 3 {
        //            projectile = SKSpriteNode(imageNamed: currentObject)
        //            projectile.size = CGSize(width: 50, height: 50)
        //
        //            addChild(projectile)
        //
        //            projectile.position.x = location.x
        //            projectile.position.y = 50
        //        }
        
        
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene?.view?.presentScene(pauseScene, transition: transition)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        // MARK: -Уничтожение объектов
        let nodeAtPoint = nodes(at: location)
        for case let node as SKSpriteNode in nodeAtPoint {
            
            // MARK: -Фрукт
            if node.name == "fruit" {
                //destroy the fruits
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                score += 1
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("great.wav", waitForCompletion: false))
            }
            
            // MARK: -Бонус-фрукт
            //            else if node.name == "bonus" {
            //                //destroy the bonus
            //                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
            //                    emitter.position = node.position
            //                    addChild(emitter)
            //                }
            //
            //                node.name = ""
            //                node.physicsBody?.isDynamic = false
            //
            //                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
            //                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            //                let group = SKAction.group([scaleOut, fadeOut])
            //
            //                let seq = SKAction.sequence([group, .removeFromParent()])
            //                node.run(seq)
            //
            //                score += 10
            //
            //                if let index = activeEnemies.firstIndex(of: node) {
            //                    activeEnemies.remove(at: index)
            //                }
            //
            //                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            //            }
            
            
            // MARK: -Противник
            else if node.name == "bomb" {
                //destroy the bomb
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                
                endGame(trigerredByBomb: true)
            }
        }
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
}

// MARK: -Helper Funcs
extension GameScene {
    
    func initScene() {
        createWorldProperties()
        createBackground()
        createPause()
        createScore()
        createLevel()
        createLives()
        createSlices()
    }
    
    func createWorldProperties() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
    }
    
    func createBackground () {
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view!.frame.size
        background.zPosition = -1
        addChild(background)
    }
    
    
    func createLevel() {
        levelLabel = SKLabelNode(text: "Level \(level)")
        levelLabel?.fontName = "Apple SD Gothic Neo Bold"
        levelLabel?.fontSize = 30
        levelLabel?.zPosition = 10
        levelLabel?.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 70)
        //        levelLabel.run(SKAction.fadeOut(withDuration: 5))
        addChild(levelLabel!)
    }
    
    
    func createLevelComplete() {
        levelLabel = SKLabelNode(text: "Level \(level) complete")
        levelLabel?.fontName = "Apple SD Gothic Neo Bold"
        levelLabel?.fontSize = 26
        levelLabel?.zPosition = 10
        levelLabel?.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 100)
        levelLabel.run(SKAction.fadeOut(withDuration: 1))
        addChild(levelLabel!)
    }
    
    
    func createGood() {
        let randomHeader = headers.randomElement()
        let header = SKSpriteNode(imageNamed: "\(randomHeader ?? "good.png")")
        header.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 150)
        header.zPosition = 15
        header.setScale(0.7)
        header.run(SKAction.fadeOut(withDuration: 0.5))
        addChild(header)
        
        //        if gameSetting.isSound {
        //            self.run(SKAction.playSoundFileNamed("bonus", waitForCompletion: false))
        //        }
    }
    
    
    func createPause() {
        let pause = ButtonNode(titled: nil, backgroundName: "menu")
        pause.anchorPoint = .zero
        pause.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 30)
        pause.name = "pause"
        pause.setScale(0.4)
        pause.zPosition = 1
        self.addChild(pause)
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Apple SD Gothic Neo Bold")
        //        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: self.size.width - 100, y: self.size.height - 50)
        gameScore.horizontalAlignmentMode = .left
        gameScore.zPosition = 1
        gameScore.fontSize = 20
        addChild(gameScore)
        
        score = 0
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.setScale(0.8)
            spriteNode.anchorPoint = .zero //CGPoint(x: 1.5, y: 0)
            spriteNode.position = CGPoint(x: CGFloat(self.size.width / 6 - CGFloat(i * 30)), y: self.size.height - 50)
            spriteNode.zPosition = 1
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = .orange
        //        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
            
        }
        
        
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("minuslife.mp3", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages [1]
        } else {
            life = livesImages [2]
            endGame(trigerredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.setScale(0.6)
//        life.xScale = 0.5
//        life.yScale = 0.5
        
        life.run(SKAction.scale(to: 0.8, duration: 0.1))
    }
}

// MARK: -Enemy
extension GameScene {
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        } else if forceBomb == .random {
            enemyType = 2
        }
        
        //        enemyType == 0 ? createBomb() : createFruit()
        
        if enemyType == 0 {
            createBomb()
        } else {
            createFruit()
        }
        
        //        if enemyType == 2 {
        //            createBonus()
        //        }
        
        
    }
    
    
    func createBomb() {
        let enemy = SKSpriteNode()
        enemy.zPosition = 1
        enemy.name = "bombContainer"
        
        let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
        bombImage.name = "bomb"
        bombImage.setScale(0.8)
        enemy.addChild(bombImage)
        
        if bombSFX != nil {
            bombSFX?.stop()
            bombSFX = nil
        }
        
        if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
            if let sound = try? AVAudioPlayer(contentsOf: path) {
                bombSFX = sound
                sound.play()
            }
        }
        
        if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
            emitter.position = CGPoint(x: 38, y: 32)                //76, 64
            enemy.addChild(emitter)
        }
        
        setEnemyOrientation(enemy: enemy)
        
        activeEnemies.append(enemy)
        addChild(enemy)
    }
    
    
    func createFruit() {
        let randomFruit = fruits.randomElement()
        //        let enemy = SKSpriteNode(imageNamed: "lemon.png")
        let fruit = SKSpriteNode(imageNamed: "\(randomFruit ?? "lemon.png")")
        fruit.setScale(0.8)
        fruit.name = "fruit"
        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        
        
        setEnemyOrientation(enemy: fruit)
        
        activeEnemies.append(fruit)
        addChild(fruit)
    }
    
    //    func createBonus() {
    //        let bonus = SKSpriteNode(imageNamed: "bonus")
    //        bonus.setScale(0.8)
    //        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
    //        bonus.name = "bonus"
    //
    //        setEnemyOrientation(enemy: bonus)
    //
    //        activeEnemies.append(bonus)
    //        //addChild(bonus)
    //    }
    
    func setEnemyOrientation(enemy: SKSpriteNode) {
        let randomPosition = CGPoint(x: Int.random(in: 1...350), y: -50) //64... 370, -128
        enemy.position = randomPosition
        
        
        let randomAngularVelocity = CGFloat.random(in: -5...5)  //-3...3
        let randomXVelocity: Int
        
        if randomPosition.x < 100 {                        //150
            randomXVelocity = Int.random(in: 1...10)       //8...15
        } else if randomPosition.x < 180 {                 //200
            randomXVelocity = Int.random(in: 1...3)        //3...5
        } else if randomPosition.x < 300 {                 //350
            randomXVelocity = -Int.random(in: 1...3)       //3...5
        } else {
            randomXVelocity = -Int.random(in: 1...10)      //8...15
        }
        
        let randomYVelocity = Int.random(in: 24...32)      //Как высоко взлетают объекты
        
        
        // MARK: -Physics
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        //        enemy.setScale(0.7)
        enemy.physicsBody!.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody!.angularVelocity = randomAngularVelocity
        enemy.physicsBody!.collisionBitMask = 0
    }
}

// MARK: -Gameplay Func
extension GameScene {
    
    func tossEnemies() {
        guard isGameEnded == false else { return }
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 5)) { [unowned self] in self.createEnemy() }
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 5)) { [unowned self] in self.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 7)) { [unowned self] in self.createEnemy() }
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    
    func endGame(trigerredByBomb: Bool) {
        guard isGameEnded == false else { return }
        
        gameSetting.currentScore = score
        gameSetting.saveScores()
        
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 0.3)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSFX?.stop()
        bombSFX = nil
        
        //Жизни
        if trigerredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
    }
    
    func winGame(trigerredByBomb: Bool) {
        guard isGameEnded == false else { return }
        
        gameSetting.currentScore = score
        gameSetting.saveScores()
        
        let winScene = WinScene(size: self.size)
        winScene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 0.3)
        self.scene!.view?.presentScene(winScene, transition: transition)
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSFX?.stop()
        bombSFX = nil
    }
    
}

// MARK: -SFX Func
extension GameScene {
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [unowned self] in
            self.isSwooshSoundActive = false
        }
    }
}
