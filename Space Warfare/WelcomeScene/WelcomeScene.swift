//
//  WelcomeScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/14/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit

class WelcomeScene: SKScene {
    
    var startGameLabel: SKLabelNode! 
    var instructionsLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    var emitter: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        
        initializeVariables()
        
        emitter.advanceSimulationTime(8)
        
    }
    
    private func initializeVariables() {
        
        startGameLabel = (self.childNode(withName: "startGame") as! SKLabelNode)
        instructionsLabel = (self.childNode(withName: "instructions") as! SKLabelNode)
        highscoreLabel = (self.childNode(withName: "highscore") as! SKLabelNode)
        
        updateHighscore()
        
        emitter = (self.childNode(withName: "emitter") as! SKEmitterNode)
        
    }
    
    private func updateHighscore() {


        let highScore = UserDefaults.standard.value(forKey: "highScore")
        if let score = highScore {
            self.highscoreLabel.text = "High Score: \(score)"
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
                
            if (nodesArray.first?.name == "startGame") {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            } else if (nodesArray.first?.name == "instructions") {
                let instructionScene = SKScene(fileNamed: "InstructionScene")!
                instructionScene.scaleMode = .aspectFill
                self.view?.presentScene(instructionScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            }

        }
        
        
        
    }

}
