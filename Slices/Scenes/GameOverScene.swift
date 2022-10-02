
import SpriteKit

class GameOverScene: ParentScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverHeader = SKSpriteNode(imageNamed: "gameover")
        gameOverHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 135)
        gameOverHeader.setScale(0.3)
        gameOverHeader.zPosition = 3
        self.addChild(gameOverHeader)
        
        let restart = ButtonNode(titled: nil, backgroundName: "btn_restart")
        restart.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 10)
        restart.name = "restart"
        restart.setScale(0.4)
        restart.zPosition = 1
        self.addChild(restart)
        
        let toMenu = ButtonNode(titled: nil, backgroundName: "btn_menu")
        toMenu.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        toMenu.name = "back"
        toMenu.setScale(0.4)
        toMenu.zPosition = 1
        self.addChild(toMenu)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart" {
            sceneManager.gameScene = nil  // приравниваем к nil, чтобы не появлялась ошибка в checkPlayer.position
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameModes(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "back" {
            
//            gameSettings.isSound = isSound
//            gameSettings.isMusic = isMusic
            
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        self.scene?.view?.presentScene(menuScene, transition: transition)
        }
    }
}
