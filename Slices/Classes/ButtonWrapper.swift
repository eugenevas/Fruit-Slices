import SpriteKit

class ButtonWrapper: SKNode {
   
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var action: () -> Void
    var isEnabled = true
    var titleLabel: SKLabelNode?
    
    init(imageNamed: String, title: String? = "", buttonAction: @escaping () -> Void) {
        button = SKSpriteNode(imageNamed: imageNamed)
        titleLabel = SKLabelNode(text: title)

        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0
        
        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        //cropNode.addChild(mask)
        
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        
        setupNodes()
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNodes() {
        button.zPosition = 0
        
        if let titleLabel = titleLabel {
            titleLabel.fontName = "AvenirNext-Bold"
            titleLabel.zPosition = 1
            titleLabel.horizontalAlignmentMode = .center
            titleLabel.verticalAlignmentMode = .center
            titleLabel.fontSize = 35
        }
    }
    
    func addNodes() {
        addChild(button)
        if let titleLabel = titleLabel {
            addChild(titleLabel)
        }
        addChild(cropNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            //mask.alpha = 0.5
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                if button.contains(location) {
                    //mask.alpha = 0.5
                } else {
                    //mask.alpha = 0.0
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                if button.contains(location) {
                    disable()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
                        self.enable()
                    })]))
                } else {
                    //mask.alpha = 0.0
                }
            }
        }
    }
    
    func disable() {
//        isEnabled = false
//        mask.alpha = 0.0
//        button.alpha = 0.5
    }
    
    func enable() {
//        isEnabled = true
//        mask.alpha = 0.0
//        button.alpha = 1.0
    }
    

    
    
    
    //===============
    
//    let label: SKLabelNode = {
   //        let l = SKLabelNode(text: "")
   //        l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
   //        l.fontName = "Apple SD Gothic Neo Bold"
   //        l.fontSize = 30
   //        l.horizontalAlignmentMode = .center
   //        l.verticalAlignmentMode = .center
   //        l.zPosition = 2
   //
   //        return l
   //    }()
   //
   //    init(titled title: String?, backgroundName: String, buttonAction: @escaping () -> Void) {
   //
   //        let texture = SKTexture(imageNamed: backgroundName)
   //
   //        super.init(texture: texture, color: .clear, size: texture.size())
   //        if let title = title {
   //            label.text = title.uppercased()
   //        }
   //        addChild(label)
   //
   //    }
   //
   //    required init?(coder aDecoder: NSCoder) {
   //        fatalError("init(coder:) has not been implemented")
   //    }
}




