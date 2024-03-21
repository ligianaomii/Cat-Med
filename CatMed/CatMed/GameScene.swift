//
//  GameScene.swift
//  CatMed
//
//  Created by Heloisa Pereira Machado on 21/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mouth: SKSpriteNode!
    var med: SKSpriteNode!
    
    var isMouthOpen = false
    
    override func didMove(to view: SKView) {
        mouth = childNode(withName: "mouth") as? SKSpriteNode
        med = childNode(withName: "med") as? SKSpriteNode
        
        med.userData = ["initialPosition": med.position]
        
        self.mouth.isHidden = true
        
        openMouth()
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        if isMouthOpen {
            moveMedTowardsMouth()
        }
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    
    }
    
    func moveMedTowardsMouth() {
        let mouthPosition = mouth.position
        
        let dx = mouthPosition.x - med.position.x
        let dy = mouthPosition.y - med.position.y
        
        let distance = sqrt(dx * dx + dy * dy)
        
        let desiredSpeed: CGFloat = 700.0
        
        let duration = TimeInterval(distance / desiredSpeed)
        
        let moveAction = SKAction.move(to: mouthPosition, duration: duration)
        
        let collisionAction = SKAction.run {
            
            if self.med.intersects(self.mouth) {
                
                print("Med collided with the mouth!")
                self.med.isHidden = true
                
            }
        }
        
        // Create a sequence of actions: move towards mouth, then check for collision
        let sequence = SKAction.sequence([moveAction, collisionAction])
        
        // Run the sequence on the med node, and repeat forever
        med.run(SKAction.repeatForever(sequence))
    }
    
    func openMouth() {
        let randomDuration = TimeInterval.random(in: 0.4...2.0)
        
        
        let waitAction = SKAction.wait(forDuration: randomDuration)
        
        let openAction = SKAction.run {
            self.mouth.isHidden = false
            self.isMouthOpen = true
            self.closeMouth()
        }
        
        let sequence = SKAction.sequence([waitAction, openAction])
        let openLoop = SKAction.repeatForever(sequence)
        mouth.run(openLoop)
        
    }
    
    func closeMouth() {
        let randomDuration = TimeInterval.random(in: 1.0...2.0)
        
        let waitAction = SKAction.wait(forDuration: randomDuration)
        
        let openAction = SKAction.run {
            self.mouth.isHidden = true
            self.isMouthOpen = false
        }
        
        let sequence = SKAction.sequence([waitAction, openAction])
        
        mouth.run(sequence)
    }
    
}

