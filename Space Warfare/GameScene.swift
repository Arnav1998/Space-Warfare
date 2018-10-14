//
//  GameScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/13/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundStarField: SKEmitterNode! = nil
    var player: SKSpriteNode! = nil
    var score = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel: SKLabelNode! = nil
    var timer: Timer! = nil
    var aliens = ["alien","alien2","alien3"]
    let alienCollisionCategory:UInt32 = 0x1 << 1
    let photonTorpedoCollisionCategory:UInt32 = 0x1 << 0
    

    override func didMove(to view: SKView) {

        setupBackgroundEmitter()
        
        addPlayer()
        
        setupPhysicsWorld()
        
        setupScoreLabel()
        
        setupTimer()
    }
    
    private func setupTimer() {
    
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAliens), userInfo: nil, repeats: true)
        
    }
    
    @objc private func addAliens() {
        
        let alien = SKSpriteNode(imageNamed: aliens[Int(arc4random_uniform(UInt32(aliens.count)))])
        
        let randomPosition = GKRandomDistribution(lowestValue: Int(self.frame.minX + alien.size.width), highestValue: Int(self.frame.maxX - alien.size.width))
        
        alien.position = CGPoint(x: CGFloat(randomPosition.nextInt()), y: self.frame.maxY)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCollisionCategory
        
        alien.physicsBody?.contactTestBitMask = photonTorpedoCollisionCategory
        
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        var actionArray = [SKAction]()
        
        let animationDuration:TimeInterval = 6
    
        actionArray.append(SKAction.move(to: CGPoint(x: alien.position.x, y: self.frame.minY-alien.size.height), duration: animationDuration))
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    private func setupScoreLabel() {
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        
        score = 0
        
        scoreLabel.position = CGPoint(x: self.frame.minX + scoreLabel.frame.size.width + 35, y: self.frame.maxY - 3*scoreLabel.frame.size.height)
        
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        
        scoreLabel.fontSize = 36
        
        self.addChild(scoreLabel)
        
    }
    
    private func setupPhysicsWorld() {
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    private func setupBackgroundEmitter() {
        
        backgroundStarField = SKEmitterNode(fileNamed: "Starfield")
        
        backgroundStarField.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        
        backgroundStarField.advanceSimulationTime(7)
        
        backgroundStarField.zPosition = -1
        
        self.addChild(backgroundStarField)
        
    }
    
    private func addPlayer() {
        
        player = SKSpriteNode(imageNamed: "player")
        
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 2*player.size.height)
        
        self.addChild(player)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
