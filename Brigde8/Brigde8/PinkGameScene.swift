//
//  GameScene.swift
//  Brigde8
//
//  Created by anshu Li on 09/03/26.
//

import SpriteKit
import GameplayKit

class PinkGameScene: SKScene {
    private var pink = SKSpriteNode()
    private var pinkWalkingFrames: [SKTexture] = []
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sceneButton() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.3)
        let gameScene = BlueGameScene(size: self.size)
        view?.presentScene(gameScene, transition: reveal)
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        buildPink()
        blueButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let tappedNodes = nodes (at: location)
        guard let tapped = tappedNodes.first else { return}
        
        if tapped.name == "blueButton" {
            sceneButton()
        } else {
            movePink(location: location)
        }
    }
    
    func buildPink() {
        let pinkAnimatedAtlas = SKTextureAtlas(named: "WalkSprite")
        var walkFrames: [SKTexture] = []
        
        let numImages = pinkAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let pinkTextureName = "sprite\(i)"
            walkFrames.append(pinkAnimatedAtlas.textureNamed(pinkTextureName))
        }
        pinkWalkingFrames = walkFrames
        
        let firstFrameTexture = pinkWalkingFrames[0]
        pink = SKSpriteNode(texture: firstFrameTexture)
        pink.position = CGPoint(x: frame.midX, y: frame.midY)
        pink.zPosition = 2
        addChild(pink)
    }
    
    func blueButton() {
        let blueButton = SKSpriteNode(imageNamed: "Dude_Monster")
        blueButton.name = "blueButton"
        blueButton.position = CGPoint(x: frame.midX, y: frame.midY / 2)
        blueButton.zPosition = 3
        addChild(blueButton)
    }
    
    func animatePink() {
        pink.run(SKAction.repeatForever(
            SKAction.animate(with: pinkWalkingFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlacePink")
    }
    
    func pinkMoveEnded() {
        pink.removeAllActions()
    }
    
    func movePink(location: CGPoint) {
        var multiplierForDirection: CGFloat
        
        let pinkSpeed = frame.size.width / 3.0
        
        let moveDifference = CGPoint(x: location.x - pink.position.x, y: location.y - pink.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        let moveDuration = distanceToMove / pinkSpeed
        
        if moveDifference.x < 0 {
            multiplierForDirection = -1.0
        } else {
            multiplierForDirection = 1.0
        }
        pink.xScale = abs(pink.xScale) * multiplierForDirection
        
        if pink.action(forKey: "walkingInPlacePink") == nil {
            animatePink()
        }
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        let doneAction = SKAction.run({ [weak self] in
            self?.pinkMoveEnded()
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        pink.run(moveActionWithDone, withKey:"pinkMoving")
    }
}
