//


import Foundation

//func createEnemy(forceBomb: ForceBomb = .random) {
//    let enemy: SKSpriteNode
//    let bonus: SKSpriteNode
//
//    var enemyType = Int.random(in: 0...6)
//    //where 0 - bomb,
//    //      1 - fruit
//    //      2 - bonus
//
//    if forceBomb == .never {
//        enemyType = 1
//    } else if forceBomb == .always {
//        enemyType = 0
//    }
//
//
//    if enemyType == 0 {
//        // MARK: -Инициализация бомбы
//        enemy = SKSpriteNode()
//        enemy.zPosition = 1
//        enemy.name = "bombContainer"
//
//        let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
//        bombImage.name = "bomb"
//        bombImage.setScale(1.2)
//        //            bombImage.zPosition = 1
//        enemy.addChild(bombImage)
//
//        if bombSFX != nil {
//            bombSFX?.stop()
//            bombSFX = nil
//        }
//
//        if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
//            if let sound = try? AVAudioPlayer(contentsOf: path) {
//                bombSFX = sound
//                sound.play()
//            }
//        }
//
//        if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
//            emitter.position = CGPoint(x: 38, y: 32)                //76, 64
//            enemy.addChild(emitter)
//        }
//    }
//
//    // MARK: -Fruits
//    else {
//        enemy = SKSpriteNode(imageNamed: "lemon")
//        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
//        enemy.name = "fruit"
//
//        bonus = SKSpriteNode(imageNamed: "bonus")
//        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
//        bonus.name = "bonus"
//    }
//
//    setEnemyOrientation(enemy: enemy)
//    activeEnemies.append(enemy)
//    addChild(enemy)
//}


//=================================================



//func createEnemy(forceBomb: ForceBomb = .random) {
//    let enemy: SKSpriteNode
//    let bonus: SKSpriteNode
//
//    var enemyType = Int.random(in: 0...6)
//    //where 0 - bomb,
//    //      1 - fruit
//    //      2 - bonus
//
//    if forceBomb == .never {
//        enemyType = 1
//    } else if forceBomb == .always {
//        enemyType = 0
//    }
//
//    //        else if forceBomb == .random {
//    //            enemyType = 2
//    //        }
//
//    if enemyType == 0 {
//        // MARK: -Инициализация бомбы
//        enemy = SKSpriteNode()
//        enemy.zPosition = 1
//        enemy.name = "bombContainer"
//
//        let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
//        bombImage.name = "bomb"
//        bombImage.setScale(1.2)
//        //            bombImage.zPosition = 1
//        enemy.addChild(bombImage)
//
//        if bombSoundEffect != nil {
//            bombSoundEffect?.stop()
//            bombSoundEffect = nil
//        }
//
//        if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
//            if let sound = try? AVAudioPlayer(contentsOf: path) {
//                bombSoundEffect = sound
//                sound.play()
//            }
//        }
//
//        if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
//            emitter.position = CGPoint(x: 38, y: 32)                //76, 64
//            enemy.addChild(emitter)
//        }
//    }
//
//    // MARK: -Fruits
//    else {
//        enemy = SKSpriteNode(imageNamed: "lemon")
//        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
//        enemy.name = "fruit"
//
//        bonus = SKSpriteNode(imageNamed: "bonus")
//        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
//        bonus.name = "bonus"
//    }
