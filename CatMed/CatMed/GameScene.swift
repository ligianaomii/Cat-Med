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
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
            didSet {
                // Atualizar o texto da label de pontuação sempre que o valor da pontuação for alterado
                scoreLabel.text = "Score: \(score)"
            }
        }
    
    var isMouthOpen = false
    
    override func didMove(to view: SKView) {
        mouth = childNode(withName: "mouth") as? SKSpriteNode
        med = childNode(withName: "med") as? SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        
        
        med.userData = ["initialPosition": med.position]
        
        
        self.mouth.isHidden = true
        
        openMouth()
        
        //        physicsWorld.contactDelegate = self
    }
    
    func touchDown(atPoint pos : CGPoint) {
        moveMedTowardsMouth()
        
        if isMouthOpen {
            increaseScore(by: 1)
        } else if !isMouthOpen {
            score = 0
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
        if med.intersects(mouth) {
            if let initialMedPosition = med.userData?["initialPosition"] as? CGPoint {
                med.position = initialMedPosition
            }
        }
    }
    
    func moveMedTowardsMouth() {
            let mouthPosition = mouth.position
            let dx = mouthPosition.x - med.position.x
            let dy = mouthPosition.y - med.position.y
            let distance = sqrt(dx * dx + dy * dy)
            let desiredSpeed: CGFloat = 700.0
            let duration = TimeInterval(distance / desiredSpeed)
            let moveAction = SKAction.move(to: mouthPosition, duration: duration)
            let sequence = SKAction.sequence([moveAction])
            med.run(sequence)
            
            // Aumentar a pontuação quando o jogador acerta a boca
            
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check if the contact is between med and mouth
        if (contact.bodyA.node == med && contact.bodyB.node == mouth) ||
            (contact.bodyA.node == mouth && contact.bodyB.node == med) {
            // Reset med's position to its initial position
            if let initialMedPosition = med.userData?["initialPosition"] as? CGPoint {
                med.position = initialMedPosition
            }
            // Remove med's movement actions
            med.removeAllActions()
        }
    }
    
    func increaseScore(by amount: Int) {
            // Aumentar a pontuação
            score += amount
        }
    
}

