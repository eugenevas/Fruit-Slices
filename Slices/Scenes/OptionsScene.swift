import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    
    override func didMove(to view: SKView) {
        
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = -1
        self.addChild(background)
        
        let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
        let music = ButtonNode(titled: nil, backgroundName: backgroundNameForMusic)
        music.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY)
        music.name = "music"
        music.setScale(0.6)
        music.zPosition = 1
        music.label.isHidden = true
        addChild(music)
        
        
        let backgroundNameForSound = isMusic == true ? "sound" : "nosound"
        let sound = ButtonNode(titled: nil, backgroundName: backgroundNameForSound)
        sound.position = CGPoint(x: self.frame.midX + 80, y: self.frame.midY)
        sound.name = "sound"
        sound.zPosition = 1
        sound.setScale(0.6)
        sound.label.isHidden = true
        addChild(sound)
        
        
        let optionsHeader = SKSpriteNode(imageNamed: "settings_header")
        optionsHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        optionsHeader.setScale(0.4)
        optionsHeader.zPosition = 1
        self.addChild(optionsHeader)
        
        let texture = SKTexture(imageNamed: "btn_menu")
        let back = SKSpriteNode(texture: texture)
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        back.name = "back"
        back.setScale(0.7)
        back.zPosition = 1
        self.addChild(back)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "music" {
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
            
        } else if node.name == "sound" {
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        }
        
        else if node.name == "back" {
            
            gameSettings.isSound = isSound
            gameSettings.isMusic = isMusic
            
            gameSettings.saveGameSettings()
            let transition = SKTransition.crossFade(withDuration: 0.2)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(backScene, transition: transition)
        }
    }
    
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
        
    }
}
