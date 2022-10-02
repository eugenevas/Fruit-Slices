import SpriteKit

class PauseScene: ParentScene {
    
    override func didMove(to view: SKView) {
       
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        
        let pauseHeader = SKSpriteNode(imageNamed: "pause_header")
        pauseHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        pauseHeader.setScale(0.5)
        pauseHeader.zPosition = 3
        self.addChild(pauseHeader)
        
        let restart = ButtonNode(titled: nil, backgroundName: "btn_restart")
        restart.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 80)
        restart.name = "restart"
        restart.setScale(0.4)
        restart.zPosition = 2
        self.addChild(restart)
        
        let options = ButtonNode(titled: nil, backgroundName: "settings")
        options.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 10)
        options.name = "options"
        options.setScale(0.4)
        options.zPosition = 2
        self.addChild(options)
        
        let resume = ButtonNode(titled: nil, backgroundName: "btn_resume")
        resume.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
        resume.name = "resume"
        resume.setScale(0.4)
        resume.zPosition = 2
        self.addChild(resume)
        
        let back = ButtonNode(titled: nil, backgroundName: "btn_menu")
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 130)
        back.name = "menu"
        back.setScale(0.4)
        back.zPosition = 2
        self.addChild(back)
   
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused{
                gameScene.isPaused = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart" {
            sceneManager.gameScene = nil  // приравниваем к nil, чтобы не появлялась ошибка в checkPlayer.position
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "options" {
            
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let optionsScene = OptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(optionsScene, transition: transition)
            
        } else if node.name == "resume" {
            
            let transition = SKTransition.crossFade(withDuration: 0.5)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "menu" {
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let menuScene = MenuScene(size: self.size)
            menuScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
}
