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

    override func didMove(to view: SKView) {

        setupBackgroundEmitter()
        
        addPlayer()
        
        setupPhysicsWorld()
        
        setupScoreLabel()
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
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
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
