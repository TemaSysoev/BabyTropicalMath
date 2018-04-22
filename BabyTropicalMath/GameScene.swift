//
//  GameScene.swift
//  TropicalMath
//
//  Created by Tema Sysoev on 03.03.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import SpriteKit
import GameplayKit
struct Karma {
    static var maxKarma = Int(0)
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Pirate   : UInt32 = 1
    static let Desk1: UInt32 = 1 << 1
    static let Desk2: UInt32 = 1 << 2
    static let Desk3: UInt32 = 1 << 3
    
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var timer = Timer()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var pirate = SKSpriteNode(imageNamed: "PirateNewBaby.png")
    
    var desk1 = SKSpriteNode(imageNamed: "OrangeNew.png")
    var desk2 = SKSpriteNode(imageNamed: "OrangeNew.png")
    var desk3 = SKSpriteNode(imageNamed: "OrangeNew.png")
    
    var karmaLabel = SKLabelNode()
    var label = SKLabelNode()
    var label1 = SKLabelNode()
    var label2 = SKLabelNode()
    var label3 = SKLabelNode()
    var karma = 0
    var a1 = Int(arc4random_uniform(5))
    var a2 = Int(arc4random_uniform(5))
    var da1 = Int(arc4random_uniform(2) + 1)
    var da2 = Int(arc4random_uniform(2) + 1)
    var znakSelector1 = Int(arc4random_uniform(2))
    var znakSelector2 = Int(arc4random_uniform(2))
    var trueSelector = Int(arc4random_uniform(3))
    
    func saveKarma(maxKarma :Int) {
        UserDefaults.standard.set(Karma.maxKarma, forKey: "maxKarma")
        print("Stored karma is ", Karma.maxKarma)
    }
    func loadKarma() -> Int{
        return UserDefaults.standard.integer(forKey:"maxKarma") > 0 ? UserDefaults.standard.integer(forKey:"maxKarma"): 4
    }
    
    func increaseKarma(maxKarma: Int){
        
        saveKarma(maxKarma: karma)
    }
    
    
    override func sceneDidLoad() {
        updateCounts()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.Update), userInfo: nil, repeats: true)
        
        
        //Pirate
        pirate.xScale = 0.2
        pirate.yScale = 0.2
        pirate.position = CGPoint(x: self.frame.midX - 200, y: self.frame.midY)
        pirate.zPosition = 1
        self.addChild(pirate)
        //
        //Brevno
        
        
        //AppleCrac
        
        //
        //Desk1
        desk1.xScale = 0.5
        desk1.yScale = 0.5
        desk1.position = CGPoint(x: pirate.position.x + 400, y: self.frame.midY + 150)
        desk1.zPosition = 0
        
        self.addChild(desk1)
        //
        
        //Desk2
        desk2.xScale = 0.5
        desk2.yScale = 0.5
        desk2.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY)
        desk2.zPosition = 0
        self.addChild(desk2)
        //
        
        //Desk3
        desk3.xScale = 0.5
        desk3.yScale = 0.5
        desk3.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY - 150)
        desk3.zPosition = 0
        self.addChild(desk3)
        //
        karmaLabel.text = "\(karma)"
        karmaLabel.fontName = "Futura"
        karmaLabel.fontColor = SKColor.black
        karmaLabel.fontSize = 24
        karmaLabel.position = CGPoint(x: -320, y: -265)
        karmaLabel.zPosition = 10
        
        
        self.addChild(karmaLabel)
        
        
        //Label1
        
        label.text = "\(a1) + \(a2)"
        label.fontName = "Futura"
        label.fontColor = SKColor.black
        label.fontSize = 24
        label.position = CGPoint(x: pirate.position.x + 400, y: self.frame.midY)
        label.zPosition = 1.1
        
        self.addChild(label)
        
        label1.fontName = "Futura"
        label1.fontColor = SKColor.black
        label1.fontSize = 24
        label1.position = CGPoint(x: desk1.position.x, y: desk1.position.y - 15)
        label1.zPosition = 0.4
        
        self.addChild(label1)
        
        
        label2.fontName = "Futura"
        label2.fontColor = SKColor.black
        label2.fontSize = 24
        label2.position = CGPoint(x: desk2.position.x, y: desk2.position.y - 15)
        label2.zPosition = 0.4
        
        self.addChild(label2)
        
        label3.fontName = "Futura"
        label3.fontColor = SKColor.black
        label3.fontSize = 24
        label3.position = CGPoint(x: desk3.position.x, y: desk3.position.y - 15)
        label3.zPosition = 0.4
        
        self.addChild(label3)
        //Physic
        //Pirate
        
        
        pirate.physicsBody = SKPhysicsBody(rectangleOf: pirate.size) // 1
        pirate.physicsBody?.isDynamic = true // 2
        pirate.physicsBody?.affectedByGravity = false
        
        pirate.physicsBody?.categoryBitMask = PhysicsCategory.Pirate
        
        pirate.physicsBody?.contactTestBitMask = PhysicsCategory.Desk1 | PhysicsCategory.Desk2 | PhysicsCategory.Desk3
        pirate.physicsBody?.collisionBitMask = 0
        pirate.shadowedBitMask = 0
        
        
        //
        
        //brevno
        
        //Desk1
        
        desk1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: desk1.xScale, height: desk1.yScale))
        desk1.physicsBody?.isDynamic = true
        desk1.physicsBody?.affectedByGravity = false
        desk1.physicsBody?.categoryBitMask = PhysicsCategory.Desk1
        desk1.physicsBody?.contactTestBitMask = PhysicsCategory.Pirate
        desk1.physicsBody?.collisionBitMask = 0
        desk1.shadowedBitMask = 0
        
        //
        
        //Desk2
        desk2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: desk2.xScale, height: desk2.yScale))
        desk2.physicsBody?.isDynamic = true
        desk2.physicsBody?.affectedByGravity = false
        
        desk2.physicsBody?.categoryBitMask = PhysicsCategory.Desk2
        desk2.physicsBody?.contactTestBitMask = PhysicsCategory.Pirate
        desk2.physicsBody?.collisionBitMask = 0
        desk2.shadowedBitMask = 0
        
        
        
        //
        
        //Desk3
        desk3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: desk3.xScale, height: desk3.yScale)) // 1
        desk3.physicsBody?.isDynamic = true // 2
        desk3.physicsBody?.affectedByGravity = false
        
        desk3.physicsBody?.categoryBitMask = PhysicsCategory.Desk3// 3
        desk3.physicsBody?.contactTestBitMask = PhysicsCategory.Pirate
        desk3.physicsBody?.collisionBitMask = 0
        desk3.shadowedBitMask = 0
        //
        
        //
        desk1.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
        desk2.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
        desk3.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
        
        
        //
        
    }
    
    
    func updateCounts(){
        print(trueSelector)
        a1 = Int(arc4random_uniform(5))
        a2 = Int(arc4random_uniform(5))
        da1 = Int(arc4random_uniform(2) + 1)
        da2 = Int(arc4random_uniform(2) + 1)
        znakSelector1 = Int(arc4random_uniform(2))
        znakSelector2 = Int(arc4random_uniform(2))
        trueSelector = Int(arc4random_uniform(3))
        label.text = "\(a1) + \(a2)"
        if trueSelector == 0 {
            label1.text = "\(a1 + a2)"
            if znakSelector1 == 0{
                label2.text = "\(a1 + a2 + da1)"
            }else{
                label2.text = "\(a1 + a2 - da1)"
            }
            if znakSelector2 == 0{
                label3.text = "\(a1 + a2 + da2)"
            }else{
                label3.text = "\(a1 + a2 - da2)"
            }
        }
        if trueSelector == 1 {
            label2.text = "\(a1 + a2)"
            if znakSelector1 == 0{
                label1.text = "\(a1 + a2 + da1)"
            }else{
                label1.text = "\(a1 + a2 - da1)"
            }
            if znakSelector2 == 0{
                label3.text = "\(a1 + a2 + da2)"
            }else{
                label3.text = "\(a1 + a2 - da2)"
            }
            
        }
        if trueSelector == 2 {
            label3.text = "\(a1 + a2)"
            if znakSelector1 == 0{
                label1.text = "\(a1 + a2 + da1)"
            }else{
                label1.text = "\(a1 + a2 - da1)"
            }
            if znakSelector2 == 0{
                label2.text = "\(a1 + a2 + da2)"
            }else{
                label2.text = "\(a1 + a2 - da2)"
            }
            
        }
        
    }
    
    
    
    @objc func Update (){
        label.position = CGPoint(x: pirate.position.x + 400, y: self.frame.midY)
        label1.position = CGPoint(x: desk1.position.x, y: desk1.position.y - 15)
        label2.position = CGPoint(x: desk2.position.x, y: desk2.position.y - 15)
        label3.position = CGPoint(x: desk3.position.x, y: desk3.position.y - 15)
        
        if label1.position.x <= -450{
            updateCounts()
            
            desk1.position = CGPoint(x: pirate.position.x + 600, y: self.frame.midY + 150)
            desk2.position = CGPoint(x: pirate.position.x + 600, y: self.frame.midY)
            desk3.position = CGPoint(x: pirate.position.x + 600, y: self.frame.midY - 150)
            desk1.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
            desk2.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
            desk3.physicsBody?.velocity = CGVector(dx: -150, dy: 0)
            self.addChild(desk1.copy() as! SKNode)
            self.addChild(desk2.copy() as! SKNode)
            self.addChild(desk3.copy() as! SKNode)
            
            label1.position = CGPoint(x: desk1.position.x, y: desk1.position.y - 15)
            label2.position = CGPoint(x: desk2.position.x, y: desk2.position.y - 15)
            label3.position = CGPoint(x: desk3.position.x, y: desk3.position.y - 15)
            self.addChild(label1.copy() as! SKNode)
            self.addChild(label2.copy() as! SKNode)
            self.addChild(label3.copy() as! SKNode)
        }
        
        
        if pirate.position.y <= (self.frame.midY + 250){
            pirate.physicsBody?.applyImpulse(CGVector(dx: 0, dy: +50))
        }
        if pirate.position.y >= (self.frame.midY - 250){
            pirate.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -50))
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        
        // desk1.physicsBody?.applyImpulse(CGVector(dx: 220, dy:0))
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        //Collision
        
        
        
        func pirateDidCollideWithDesk1(pirate:SKSpriteNode, desk1:SKSpriteNode) {
            
            
            if trueSelector == 0{
                label1.text = "+"
                label2.text = " "
                label3.text = " "
                karma = karma + 1
            }else{
                label1.text = "-"
                label2.text = " "
                label3.text = " "
                karma = karma - 1
            }
            karmaLabel.text = "\(karma)"
            if karma > Karma.maxKarma {
                Karma.maxKarma = karma
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Pirate != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Desk1 != 0)) {
            pirateDidCollideWithDesk1(pirate: firstBody.node as! SKSpriteNode, desk1: secondBody.node as! SKSpriteNode)
            
        }
        func pirateDidCollideWithDesk2(pirate:SKSpriteNode, desk2:SKSpriteNode) {
            
            
            if trueSelector == 1{
                print("N", karma)
                karma = karma + 1
                print("E", karma)
                print("ok1")
                label1.text = " "
                label2.text = "+"
                label3.text = " "
            }else{
                karma = karma - 1
                print("ok2")
                label1.text = " "
                label2.text = "-"
                label3.text = " "
            }
            karmaLabel.text = "\(karma)"
            if karma > Karma.maxKarma {
                Karma.maxKarma = karma
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Pirate != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Desk2 != 0)) {
            pirateDidCollideWithDesk2(pirate: firstBody.node as! SKSpriteNode, desk2: secondBody.node as! SKSpriteNode)
            
        }
        func pirateDidCollideWithDesk3(pirate:SKSpriteNode, desk3:SKSpriteNode) {
            
            if trueSelector == 2{
                print("ok3")
                karma = karma + 1
                label1.text = " "
                label2.text = " "
                label3.text = "+"
            }else{
                karma = karma - 1
                label1.text = " "
                label2.text = " "
                label3.text = "-"
            }
            karmaLabel.text = "\(karma)"
            if karma > Karma.maxKarma {
                Karma.maxKarma = karma
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Pirate != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Desk3 != 0)) {
            pirateDidCollideWithDesk3(pirate: firstBody.node as! SKSpriteNode, desk3: secondBody.node as! SKSpriteNode)
            
        }
        //
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //pirate.position.y = pos.y
    
        //pirate.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
        let animationPos = SKAction.move(to: CGPoint(x: pirate.position.x, y: pos.y), duration: 0.7)
        let animation1 = SKAction.animate(with: [SKTexture.init(imageNamed: "PirateNewBaby2.png")], timePerFrame: 1)
        
        //var animation = SKAction.animate(with: [SKTexture.init(imageNamed: "Pirate0.png")], timePerFrame: 1)
        pirate.run(animationPos)
        pirate.run(animation1)
        
        //pirate.run(animation)
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
        let animation2 = SKAction.animate(with: [SKTexture.init(imageNamed: "PirateNewBaby.png")], timePerFrame: 1)
        pirate.run(animation2)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        
    }
}

