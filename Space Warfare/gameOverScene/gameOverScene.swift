//
//  gameOverScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/18/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit

class gameOverScene: SKScene {
    
    var playAgainLabel: SKLabelNode!
    var scoreLabel:SKLabelNode!
    var highScoreLabel:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        initializeVariables()
        
    }
    
    private func initializeVariables() {
        
        playAgainLabel = (self.childNode(withName: "playAgain") as! SKLabelNode)
        scoreLabel = (self.childNode(withName: "score") as! SKLabelNode)
        highScoreLabel = (self.childNode(withName: "highScore") as! SKLabelNode)
        
        updateHighscore()
        
    }
    
    private func updateHighscore() {
        
        
        let highScore = UserDefaults.standard.value(forKey: "highScore")
        if let score = highScore {
            self.highScoreLabel.text = "High Score: \(score)"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "playAgain") {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            }
            
        }
        
    }

}
