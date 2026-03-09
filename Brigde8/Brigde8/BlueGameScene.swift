//
//  BlueGameScene.swift
//  Brigde8
//
//  Created by anshu Li on 09/03/26.
//

import Foundation
import SpriteKit
import GameplayKit

class BlueGameScene: SKScene {
    private var blue = SKSpriteNode()
    private var blueWalkingFrames: [SKTexture] = []
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sceneButton() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.3)
        let gameScene = PinkGameScene(size: self.size)
        view?.presentScene(gameScene, transition: reveal)
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        buildBlue()
        pinkButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let tappedNodes = nodes (at: location)
        guard let tapped = tappedNodes.first else { return}
        
        if tapped.name == "pinkButton" {
            sceneButton()
        } else {
            moveBlue(location: location)
        }
    }
    
    func buildBlue() {
        let blueAnimatedAtlas = SKTextureAtlas(named: "BlueWalkSprite")
        var walkFrames: [SKTexture] = []
        
        let numImages = blueAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let blueTextureName = "blue\(i)"
            walkFrames.append(blueAnimatedAtlas.textureNamed(blueTextureName))
        }
        blueWalkingFrames = walkFrames
        
        let firstFrameTexture = blueWalkingFrames[0]
        blue = SKSpriteNode(texture: firstFrameTexture)
        blue.position = CGPoint(x: frame.midX, y: frame.midY)
        blue.zPosition = 2
        addChild(blue)
    }
    
    func pinkButton() {
        let pinkButton = SKSpriteNode(imageNamed: "Pink_Monster")
        pinkButton.name = "pinkButton"
        pinkButton.position = CGPoint(x: frame.midX, y: frame.midY / 2)
        pinkButton.zPosition = 3
        addChild(pinkButton)
    }
    
    func animateBlue() {
        blue.run(SKAction.repeatForever(
            SKAction.animate(with: blueWalkingFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlaceBlue")
    }
    
    func blueMoveEnded() {
        blue.removeAllActions()
    }
    
    func moveBlue(location: CGPoint) {
        var multiplierForDirection: CGFloat
        
        let blueSpeed = frame.size.width / 3.0
        
        let moveDifference = CGPoint(x: location.x - blue.position.x, y: location.y - blue.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        let moveDuration = distanceToMove / blueSpeed
        
        if moveDifference.x < 0 {
            multiplierForDirection = -1.0
        } else {
            multiplierForDirection = 1.0
        }
        blue.xScale = abs(blue.xScale) * multiplierForDirection
        
        if blue.action(forKey: "walkingInPlaceBlue") == nil {
            // if legs are not moving, start them
            animateBlue()
        }
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        let doneAction = SKAction.run({ [weak self] in
            self?.blueMoveEnded()
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        blue.run(moveActionWithDone, withKey:"blueMoving")
    }
}
