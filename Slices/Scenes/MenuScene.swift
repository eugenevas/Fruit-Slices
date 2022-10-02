
import SpriteKit

class MenuScene: ParentScene {
    
    var places: [Int]!
    let highscore = UserDefaults.standard.integer(forKey: "highscore")
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadScores()
        places = gameSettings.highscore
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        let logo = SKSpriteNode(imageNamed: "joker1")
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        logo.setScale(0.9)
        logo.zPosition = 1
//        self.addChild(logo)
        
        
        let scoreLabel = SKLabelNode()
        //        scoreLabel.text = "Highscore: "
        scoreLabel.text = "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))"
        scoreLabel.position = CGPoint(x: self.frame.midX - 30, y: self.frame.midY )
        scoreLabel.fontName = "Apple SD Gothic Neo"
        scoreLabel.fontSize = 24
        scoreLabel.zPosition = 1
//        self.addChild(scoreLabel)
        
        // MARK: -Отображение Highscore
        //        for (_, value) in places.enumerated() {
        //            let countScores = SKLabelNode(text: value.description)
        //                    countScores.position = CGPoint(x: self.frame.midX + 70, y: self.frame.midY + 30)
        //                    countScores.fontName = "Apple SD Gothic Neo"
        //                    countScores.fontSize = 26
        //                    countScores.zPosition = 2
        //                    addChild(countScores)
        //        }
        
        
        let play = ButtonNode(titled: nil, backgroundName: "btn_play")
        play.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        play.name = "play"
        play.setScale(0.35)
        play.zPosition = 1
        self.addChild(play)
        
        let options = ButtonNode(titled: nil, backgroundName: "btn_settings")
        options.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 30)
        options.name = "options"
        options.setScale(0.4)
        options.zPosition = 1
        self.addChild(options)
        
        let best = ButtonNode(titled: nil, backgroundName: "btn_best")
        best.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 110)
        best.name = "best"
        best.setScale(0.4)
        best.zPosition = 1
        self.addChild(best)
        
        
//        let texture = SKTexture(imageNamed: "btn_tutorial")
//        let tutorial = SKSpriteNode(texture: texture)
        let tutorial = ButtonNode(titled: nil, backgroundName: "btn_tutorial")
        tutorial.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 190)
        tutorial.name = "tutorial"
        tutorial.setScale(0.4)
        tutorial.zPosition = 1
        self.addChild(tutorial)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "play" {
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 0.1)
            let gameScene = GameModes(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "tutorial" {
            let transition = SKTransition.crossFade(withDuration: 0.2)
            let tutorialScene = TutorialScene(size: self.size)
            tutorialScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(tutorialScene, transition: transition)
            
        } else if node.name == "options" {
            let transition = SKTransition.crossFade(withDuration: 0.2)
            let optionsScene = OptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(optionsScene, transition: transition)
            
        } else if node.name == "best" {
            let transition = SKTransition.crossFade(withDuration: 0.2)
            let optionsScene = BestScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(optionsScene, transition: transition)
        }
    }
    
}
