//
//  GameScene.swift
//  Space Warfare
//
//  Created by ARNAV SINGHANIA on 10/13/18.
//  Copyright © 2018 Kay Bee Development. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var backgroundStarField: SKEmitterNode!
    var player: SKSpriteNode!
    var score = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel: SKLabelNode!
    var timer: Timer!
    var aliens = ["alien","alien2","alien3"]
    let alienCollisionCategory:UInt32 = 0x1 << 1
    let photonTorpedoCollisionCategory:UInt32 = 0x1 << 0
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var lives: [SKSpriteNode]!
//    var backgroundMusicAction = SKAction.repeatForever(SKAction.playSoundFileNamed("backgroundMusic.mp3", waitForCompletion: true))

    override func didMove(to view: SKView) {
        
//        playBackgroundMusic()

        setupBackgroundEmitter()
        
        addLives()
        
        addPlayer()
        
        setupPhysicsWorld()
        
        setupScoreLabel()
        
        setupTimer()
        
        setupMotionManager()
    }
    
//    private func playBackgroundMusic() {
//
//        self.run(backgroundMusicAction)
//
//    }
    
    private func addLives() {
        
        lives = [SKSpriteNode]()
        
        for i in 1...3 {
            
            let liveNode = SKSpriteNode(imageNamed: "player")
            liveNode.position = CGPoint(x: self.frame.width/2 - CGFloat(5-i)*liveNode.size.width, y: self.frame.maxY - 60.0)
            self.addChild(liveNode)
            lives.append(liveNode)
            
        }

    }
    
    private func setupMotionManager() {
    
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            
            if let accelerationData = data {
                
                let acceleration = accelerationData.acceleration
                
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
            
        }
        
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
        
        actionArray.append(SKAction.run {
            
            if (self.lives.count > 0) {
                
                let liveNode = self.lives.first
                liveNode!.removeFromParent()
                
                self.lives.removeFirst()
                
                if (self.lives.count == 0) {
                    
                    let gameOverScene = SKScene(fileNamed: "gameOverScene") as! gameOverScene
                    self.view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                    gameOverScene.scoreLabel.text = "Score: \(self.score)"
                    
                }
                
            }
            
        })
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    private func setupScoreLabel() {
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        
        score = 0
        
        scoreLabel.position = CGPoint(x: self.frame.minX + scoreLabel.frame.size.width + 55, y: self.frame.maxY - 3*scoreLabel.frame.size.height)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    private func fireTorpedo() {
        
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedo = SKSpriteNode(imageNamed: "torpedo")
        
        torpedo.position = CGPoint(x: player.position.x, y: player.position.y+player.size.height/2)
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width/2)
        
        torpedo.physicsBody?.isDynamic = true
        
        torpedo.physicsBody?.categoryBitMask = photonTorpedoCollisionCategory
        
        torpedo.physicsBody?.contactTestBitMask = alienCollisionCategory
        
        torpedo.physicsBody?.collisionBitMask = 0
        
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedo)
        
        var actionArray = [SKAction]()
        
        let animationDuration:TimeInterval = 0.5
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.maxY+torpedo.size.height), duration: animationDuration))
        
        actionArray.append(SKAction.removeFromParent())
        
        torpedo.run(SKAction.sequence(actionArray))
        
    }

}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        
        explosion?.position = (contact.bodyA.node?.position)!
        
        self.addChild(explosion!)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        contact.bodyA.node?.removeFromParent()
        
        contact.bodyB.node?.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            
            explosion?.removeFromParent()
            
        }
        
        score += 5 
        
    }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        
        if (player.position.x > self.frame.maxX) {
            player.position.x = self.frame.minX
        } else if (player.position.x < self.frame.minX){
            player.position.x = self.frame.maxX
        }
    }
    
}
