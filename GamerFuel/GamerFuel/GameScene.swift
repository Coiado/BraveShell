//
//  GameScene.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 09/06/16.
//  Copyright (c) 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import SpriteKit
import GameController

/**
 *  Describes the colision mask between nodes
 */
struct PhysicsCategories {
    static let Hero      :UInt32 = 0x1 << 0
    static let Crosshair :UInt32 = 0x1 << 1
    static let None      :UInt32 = 0x1 << 2
    static let Enemy     :UInt32 = 0x1 << 3
    static let floor     :UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - outlets
    //MARK: - properties
    var hero: SKSpriteNode?
    var crosshair: SKSpriteNode?
    var background:SKSpriteNode?
    var bgImage: SKSpriteNode?
    var floor:SKSpriteNode?
    var startTime:NSDate?
    var endDate:NSDate?
    
    var healthLbl:SKLabelNode?
    var pointsLbl:SKLabelNode?
    var gameOverLabel:SKLabelNode?
    
    var health = 100
    
    var gameOver = false
    var isJumping = false
    var enemyContact = false
    
    var numOfPoints:Int = 0
    
    //Life cycle view
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.createBacground()
        
        self.healthLbl = SKLabelNode(fontNamed: "Arial")
        self.healthLbl?.text = "HEALTH: \(health)"
        self.healthLbl?.position = CGPointMake(self.frame.width * 0.9, self.frame.height * 0.95)
        self.healthLbl?.fontSize = 20
        self.addChild(healthLbl!)
        
        self.pointsLbl = SKLabelNode(fontNamed: "Arial")
        self.pointsLbl?.text = "POINTS: \(numOfPoints)"
        self.pointsLbl?.position = CGPointMake(self.frame.width * 0.1, self.frame.height * 0.95)
        self.pointsLbl?.fontSize = 20
        self.addChild(pointsLbl!)
        
        
        self.createHero()
        self.createCrosshair()
        
        print(self.view?.frame.width)
        
        
        //set the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 1
        borderBody.restitution = 0
        self.physicsBody = borderBody
        self.name = "edge"
    
        
        //crosshair config
        self.crosshairMoviment(self.crosshair!)
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(4.0)
                ])
            ))

    }
    
    
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        

        
        if gameOver{
            self.restartTheGame()
        }
    }
   
    //MARK: - Screen update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
     
        
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            if enemy.position.y <= 0 {
                self.updateEnemy(enemy)
            }
        }
        self.updatePoints()
        
        
    }
    
    func createBacground(){
        background = SKSpriteNode(imageNamed: "back_placeholder")
        background!.position = CGPointMake(self.size.width/2, self.size.height/2);
        self.addChild(background!)
        print("BACKGROUND")
        
    }
    
    
    
    //MARK: - Node creation Methods
    
    /**
     create a caracter to represent the hero
     */
    func createHero(){
        
        hero = SKSpriteNode(imageNamed: "fulero_placeholder")
        hero!.xScale = 0.05
        hero!.yScale = 0.05
        hero!.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMinY(self.frame) + CGRectGetMaxY(hero!.frame)  ) )
        hero!.physicsBody = SKPhysicsBody(rectangleOfSize: hero!.size)
        hero!.physicsBody?.usesPreciseCollisionDetection = true
        hero!.physicsBody?.collisionBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero!.physicsBody?.categoryBitMask = PhysicsCategories.Hero
        hero!.physicsBody?.contactTestBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero!.physicsBody?.allowsRotation = false
        hero!.physicsBody?.friction = 0
        hero!.physicsBody?.restitution = 0
        hero!.physicsBody?.linearDamping = 0
        hero?.physicsBody?.angularDamping = 0
        hero!.physicsBody?.mass = 28
        hero!.physicsBody?.affectedByGravity  = true
        hero?.physicsBody?.dynamic = true
        hero!.name = "hero"
        self.addChild(hero!)
        print("HERO")

        

        
    }
    /**
     create a crosshair to guide the player jump  during the gameplay
     */
    func createCrosshair(){
        
        self.crosshair = SKSpriteNode(imageNamed: "Spaceship")
        crosshair!.xScale = 0.7
        crosshair!.yScale = 0.7
        crosshair!.position = CGPoint(x: CGRectGetMinX(hero!.frame)/50, y: (CGRectGetMaxY(hero!.frame)+200))
        crosshair!.name = "small"
        hero!.addChild(crosshair!)
        print("CROSSHAIR")


    }
    
    //Essential funtions to generate the position of born of the enemies
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func randomInRange(low: CGFloat, high: CGFloat) -> CGFloat {
        let value = CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX)
        return value * (high - low) + low
    }

    func radiansToVector(radians: CGFloat) -> CGVector {
        return CGVector(dx: cos(radians), dy: sin(radians))
    }


    /**
     add an enemy on the screen
     */
    func addEnemy(){
        let kCCHaloLowAngle : CGFloat  = (200.0 * 3.14) / 180.0;
        let kCCHaloHighAngle : CGFloat  = (340.0 * 3.14) / 180.0;
        let kCCHaloSpeed: CGFloat = 100.0;
        
        
        let enemy = SKSpriteNode(imageNamed: "minioneagle_placeholder")
        
         let direction : CGVector  = radiansToVector(randomInRange(kCCHaloLowAngle, high: kCCHaloHighAngle));
        
        enemy.physicsBody?.velocity = CGVectorMake(direction.dx * kCCHaloSpeed, direction.dy * kCCHaloSpeed)
        
        enemy.xScale = 0.1
        enemy.yScale = 0.1
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        enemy.name = "enemy"
        
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.height)
        
        
        enemy.position = CGPointMake(random(min: enemy.size.width * 0.5, max: self.size.width - (enemy.size.width * 0.5)), self.size.height + (enemy.size.height * 0.5))
        addChild(enemy)
        
        let actualDuration = random(min: CGFloat(5), max: CGFloat(10.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -10), duration: NSTimeInterval(actualDuration))
        //let actionMoveDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove]))

    }
    
    //MARK - Crosshair movient
    func crosshairMoviment(node:SKSpriteNode){
        let firstMoviment = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 1)
        let clockWiseMoviment = SKAction.rotateByAngle(CGFloat(2 * (-M_PI_2)), duration: 1)
        let antiClockWiseMoviment = SKAction.rotateByAngle(CGFloat(2 * (M_PI_2)), duration: 1)
        
        let action = SKAction.repeatActionForever(SKAction.sequence([clockWiseMoviment,antiClockWiseMoviment]))
        
        node.runAction(firstMoviment, withKey:"firstMovment")
        node.runAction(action,withKey:"crosshairAction")
        
    }
    

    
    
    
    //Low level press events
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        if gameOver == false {
            for item in presses {
                
                if item.type == .PlayPause{
                    print("pressed")
                    self.startTime = NSDate()
                    crosshair?.removeAllActions()
                    
                }
            }

        }
    }
    
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        if gameOver == false {
            
            for item in presses {
                if item.type == UIPressType.PlayPause {
                    self.endDate = NSDate()
                    let timePressed = CFDateGetTimeIntervalSinceDate(endDate, startTime)
                    
                    if isJumping == false {
                        
                        if timePressed < 0.2 {
                            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                            self.jump((self.frame.height) * 0.3)
                        }else
                            if timePressed > 0.5 {
                                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                                self.jump((self.frame.height) * 0.8)
                                
                            }else {
                                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                                self.jump((self.frame.height) * 0.2)
                        }
                        
                    }
                    
                    print("released\(timePressed)")
                    self.crosshair?.zRotation = 0.0
                    self.crosshair?.zPosition = 0.0
                    
                    
                    self.crosshairMoviment(crosshair!)
                    
                }
            }
            
        }

    }
    
    //MARK:- impulse action

    /**
     Perform a jump in  scree
     
     - parameter yAxis: CGFloat
     */
    func jump(yAxis:CGFloat){
        let cross = self.childNodeWithName("small")
        isJumping = true
        
        let xDirection = CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1))
        // move up 20
        //let jumpUpAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)),y:yAxis, duration: 0.5)
        // move down 20
        //let jumpDownAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)), y: -1 * yAxis,duration:0.8)
        
        let jumpUpAction = SKAction.moveByX(xDirection,y:yAxis, duration: 0.5)
        let jumpDownAction = SKAction.moveByX(xDirection,y: -1 * 0, duration: 0.5)
        
        // sequence of move yup then down
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        
        // make player run sequence
        hero!.runAction(jumpSequence)

        
    }
    


    
    
    //MARK: - Colision detect
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody:SKPhysicsBody
        let secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0) && ((secondBody.categoryBitMask & PhysicsCategories.floor) != 0) {
            print("HIT THE FLOOR")
            isJumping = false

            
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Enemy) != 0)) {
            self.removeEnemy(secondBody.node as! SKSpriteNode)
            print("HIT AN ENEMY")
            if gameOver == false{
                self.numOfPoints += 20
                self.enemyContact = true

            }
        }
    }
    
    //MARK:- Game actions
    func removeEnemy(enemy:SKSpriteNode){
        enemy.removeFromParent()
    }
    
    func updateEnemy(enemy:SKNode){
        
        if enemy.position.y < 0 {
            
            if gameOver == false {
                enemy.removeFromParent()
                health -= 10
                self.healthLbl?.text = "HEALTH: \(health)"
                
            }
            
            if health == 0 {
                gameOver = true
                self.isGameOver()
                enemy.removeFromParent()
            }
            
        }
    }
    
    func updatePoints(){
        if enemyContact {
            self.pointsLbl?.text = "POINTS: \(numOfPoints)"
        }
    }
    
    /**
     ends the game
     */
    func isGameOver(){
        self.gameOverLabel?.removeFromParent()

        self.gameOver = true
        self.gameOverLabel = SKLabelNode(fontNamed: "Arial")
        self.gameOverLabel?.text = " GAME OVER"
        self.gameOverLabel?.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.gameOverLabel?.fontSize = 20
        self.addChild(gameOverLabel!)

    }
    /**
     Restart all the stats of game
     */
    func restartTheGame(){
        self.gameOver = false
        self.health = 100
        self.numOfPoints = 0
        self.healthLbl?.text = "HEALTH: \(health)"
        self.gameOverLabel?.removeFromParent()
        
        //get all the nodes with the same type
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            enemy.removeFromParent()
        }
        
        
    }

    
}
