import SpriteKit

class TutorialScene: SKScene {
    
    let sceneManager = SceneManager.shared
//    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        let tapToBegin = SKLabelNode(text: "Tap here to begin")
        tapToBegin.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.7)
        tapToBegin.fontName = "MyFont"
        tapToBegin.name = "tapToBegin"
        tapToBegin.fontSize = 22
        tapToBegin.zPosition = 1
        self.addChild(tapToBegin)
        
        let swipeLabel = SKLabelNode(text: "Swipe to destroy fruits")
        swipeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
        swipeLabel.fontName = "MyFont"
        swipeLabel.name = "tapToBegin"
        swipeLabel.fontSize = 22
        swipeLabel.zPosition = 1
        self.addChild(swipeLabel)
        
        
        let lemon = SKSpriteNode(imageNamed: "lemon")
        lemon.position = CGPoint(x: self.frame.width * 0.8, y: self.frame.height * 0.6)
        lemon.setScale(0.8)
        lemon.zPosition = 1
        lemon.zRotation = .pi * -0.2
        self.addChild(lemon)
        
        let watermelon = SKSpriteNode(imageNamed: "watermelon")
        watermelon.setScale(0.8)
        watermelon.position = CGPoint(x: self.frame.width * 0.25, y: self.frame.height * 0.8)
        watermelon.zPosition = 1
        watermelon.zRotation = .pi * 0.2
        self.addChild(watermelon)
        
        let enemy = SKSpriteNode(imageNamed: "sliceBomb")
        enemy.setScale(0.8)
        enemy.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.3)
        enemy.zPosition = 1
        enemy.zRotation = .pi * -0.2
        self.addChild(enemy)
        
        
        let texture = SKTexture(imageNamed: "btn_menu")
        let menuButton = SKSpriteNode(texture: texture)
        menuButton.anchorPoint = .zero
        menuButton.position = CGPoint(x: self.frame.width * 0.05, y: self.frame.height - 80)
        menuButton.name = "menu"
        menuButton.xScale = 0.4
        menuButton.yScale = 0.4
        menuButton.zPosition = 1
        self.addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "menu" {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let menuScene = MenuScene(size: self.size)
            menuScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
        if node.name == "tapToBegin" {
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameModes(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        
    }
}
