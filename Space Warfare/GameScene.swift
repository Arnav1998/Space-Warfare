//
//  GameScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/13/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
