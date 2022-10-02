
import SpriteKit

class GameModes: ParentScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        addChild(background)
        
        let menu = ButtonNode(titled: nil, backgroundName: "btn_menu")
        menu.position = CGPoint(x: self.size.width * 0.1, y: self.size.height - 50)
        menu.name = "menu"
        menu.setScale(0.4)
        menu.zPosition = 1
        self.addChild(menu)
        
        
        let endlessButton = ButtonWrapper(imageNamed: "endless", buttonAction: endlessButtonPressed)
        endlessButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        endlessButton.name = "endless"
        endlessButton.setScale(0.4)
        endlessButton.zPosition = 1
        addChild(endlessButton)
        
        let historyButton = ButtonWrapper(imageNamed: "history", buttonAction: historyButtonPressed)
        historyButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 30)
        historyButton.name = "history"
        historyButton.setScale(0.4)
        historyButton.zPosition = 1
        addChild(historyButton)
    }
    
    func endlessButtonPressed() {
        presentGameScene(with: .endless)
    }
    
    func historyButtonPressed() {
        presentGameScene(with: .history)
    }
        
    func presentGameScene(with gameMode: GameMode) {
    let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        gameScene.gameMode = gameMode
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(gameScene, transition: transition)
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
    }
}
