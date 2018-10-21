//
//  InstructionScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/20/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit

class InstructionScene: SKScene {
    
    var playNowLabel:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        playNowLabel = (self.childNode(withName: "playNow") as! SKLabelNode)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "playNow") {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            }
            
        }
        
    }
    

}
