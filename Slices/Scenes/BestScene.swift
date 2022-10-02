
import SpriteKit

class BestScene: ParentScene {
    
    var places: [Int]!
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadScores()
        places = gameSettings.highscore
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        gameSettings.loadScores()
        places = gameSettings.highscore
        
        let bestHeader = SKSpriteNode(imageNamed: "best_header")
        bestHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        bestHeader.setScale(0.5)
        bestHeader.zPosition = 1
        self.addChild(bestHeader)
        
        let texture = SKTexture(imageNamed: "btn_menu")
        let back = SKSpriteNode(texture: texture)
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        back.name = "back"
        back.setScale(0.7)
        back.zPosition = 1
        self.addChild(back)
        
        
        //Отображение подсчитанных резульататов
        for (index, value) in places.enumerated() {
            let scoreLabel = SKLabelNode(text: value.description)
            scoreLabel.fontColor = .white
            scoreLabel.fontName = "Apple SD Gothic Neo Bold"
            scoreLabel.fontSize = 30
            scoreLabel.zPosition = 1
            scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100 - CGFloat(index * 60))
            addChild(scoreLabel)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "back" {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(backScene, transition: transition)
        }
    }
}


