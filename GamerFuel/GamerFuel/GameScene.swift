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
    var bgImage: SKSpriteNode?
    var floor:SKSpriteNode?
    var startTime:NSDate?
    var endDate:NSDate?
    
    var numOfPoints:Int = 0
    
    //Life cycle view
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        bgImage = SKSpriteNode(imageNamed:"espaco")
        self.addChild(bgImage!)
        bgImage!.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        
        self.createHero()
        self.createCrosshair()
        
        
        
        //set the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody.init(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategories.floor
        self.physicsBody?.contactTestBitMask = PhysicsCategories.floor | PhysicsCategories.Hero
        self.physicsBody?.collisionBitMask = PhysicsCategories.floor | PhysicsCategories.Hero
        self.name = "edge"
    
        // 1
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2
        borderBody.friction = 0
        // 3
        self.physicsBody = borderBody
        
        //crosshair config
        self.crosshairMoviment(self.crosshair!)
        

        
        //set controller
        self.setControllersEvents()
        

    }
    
    
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        //print("touch")
        self.jumpPlayer()
    }
   
    //MARK: - Screen update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (hero?.position.y)! == ((self.hero?.frame.height)! + 100) {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        }
        
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            if enemy.position.y <= 0 {
                self.updateEnemy(enemy)
            }
        }
    }
    
    
    
    //MARK: - Node creation Methods
    
    /**
     create a caracter to represent the hero
     */
    func createHero(){
        
        hero = SKSpriteNode(imageNamed: "Spaceship")
        hero!.xScale = 0.1
        hero!.yScale = 0.1
        hero!.position = CGPoint(x: CGRectGetMidX(self.frame), y:((self.hero?.frame.height)! + 100))
        hero!.physicsBody = SKPhysicsBody(rectangleOfSize: hero!.size)
        hero!.physicsBody?.usesPreciseCollisionDetection = true
        hero!.physicsBody?.collisionBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero!.physicsBody?.categoryBitMask = PhysicsCategories.Hero
        hero!.physicsBody?.contactTestBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero!.physicsBody?.allowsRotation = false
        hero!.physicsBody?.friction = 0
        hero!.physicsBody?.linearDamping = 0
        hero!.physicsBody?.mass = self.frame.height * self.frame.width
        hero!.physicsBody?.affectedByGravity  = true
        hero!.name = "hero"
        self.addChild(hero!)

        
    }
    /**
     create a crosshair to guide the player jump  during the gameplay
     */
    func createCrosshair(){
        
        self.crosshair = SKSpriteNode(imageNamed: "Spaceship")
        crosshair!.xScale = 0.2
        crosshair!.yScale = 0.2
        crosshair!.position = CGPoint(x: CGRectGetMinX(hero!.frame)/50, y: (CGRectGetMaxY(hero!.frame)+50))
//        crosshair!.physicsBody = SKPhysicsBody(rectangleOfSize: crosshair!.size)
//        crosshair!.physicsBody?.usesPreciseCollisionDetection = true
//        crosshair!.physicsBody?.categoryBitMask = PhysicsCategories.Crosshair
//        crosshair!.physicsBody?.collisionBitMask = PhysicsCategories.Crosshair | PhysicsCategories.Hero
//        crosshair!.physicsBody?.dynamic = false
        crosshair!.name = "small"
        hero!.addChild(crosshair!)

    }
    
    //Essential funtions to generate the position of born of the enemies
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    /**
     add an enemy on the screen
     */
    func addEnemy(){
        let enemy = SKSpriteNode(imageNamed: "Spaceship")
        
        enemy.xScale = 0.1
        enemy.yScale = 0.1
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        enemy.name = "enemy"
        
        //it needs to be improved
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.height/2)
        
        enemy.position = CGPoint(x:actualX,  y: size.height + enemy.size.height/2)
        
        addChild(enemy)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: 0), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))

    }
    
    //MARK - Crosshair movient
    func crosshairMoviment(node:SKSpriteNode){
        let firstMoviment = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 1)
        let clockWiseMoviment = SKAction.rotateByAngle(CGFloat(2 * (-M_PI_2)), duration: 1)
        let antiClockWiseMoviment = SKAction.rotateByAngle(CGFloat(2 * (M_PI_2)), duration: 1)
        
        let action = SKAction.repeatActionForever(SKAction.sequence([clockWiseMoviment,antiClockWiseMoviment]))
        
        node.runAction(firstMoviment)
        node.runAction(action,withKey:"crosshairAction")
        
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(1.0)
                ])
            ))

    }
    
    //MARK: - Controller events mehtods
    
    func setControllersEvents(){
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view!.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view!.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .Up
        view!.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .Down
        view!.addGestureRecognizer(swipeDown)
        
        

    }
    
    //MARK:- impulse action
    func jumpPlayer() {
        // 1
        let impulse =  CGVector(dx: 0, dy: 75)
        // 2
        hero!.physicsBody?.applyImpulse(impulse)
    }

    
    
    // Handle Swipe Events
    func swipedRight(sender:UISwipeGestureRecognizer){
        hero!.position = CGPoint(x: hero!.position.x + 10, y: hero!.position.y)
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        hero!.position = CGPoint(x: (hero!.position.x - 10), y: hero!.position.y)
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        hero!.position = CGPoint(x: hero!.position.x, y: hero!.position.y+10)
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        hero!.position = CGPoint(x: hero!.position.x, y: hero!.position.y-10)
    }
    
    func tapped(sender:UITapGestureRecognizer){
        print("play/Pause pressed")
        
        // move up 20
        let jumpUpAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)),y:40, duration: 0.2)
        // move down 20
        let jumpDownAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)), y: -40,duration:0.2)
        
        // sequence of move yup then down
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        
        // make player run sequence
        hero!.runAction(jumpSequence)
    }
    
    
    //Low level press events
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {

            if item.type == .PlayPause{
                print("pressed")
                self.startTime = NSDate()
                self.removeActionForKey("crosshairAction")
                
            }
        }
    }
    
    func jump(yAxis:CGFloat){
        let cross = self.childNodeWithName("small")
        
        print("cross \(cross)")
        // move up 20
        let jumpUpAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)),y:yAxis, duration: 0.5)
        // move down 20
        let jumpDownAction = SKAction.moveByX(CGFloat(((crosshair!.zRotation * 180)/CGFloat(M_PI)) * (-1)), y: -1 * yAxis,duration:0.8)
        
        // sequence of move yup then down
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        
        // make player run sequence
        hero!.runAction(jumpSequence)

        
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == UIPressType.PlayPause {
                //self.view!.backgroundColor = UIColor.whiteColor()
                self.endDate = NSDate()
                let timePressed = CFDateGetTimeIntervalSinceDate(endDate, startTime)
                if timePressed < 0.2 {
                    self.jump((self.frame.height) * 0.3)
                }else
                if timePressed > 0.5 {
                    //self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                    self.jump((self.frame.height) * 0.8)

                }else {
                    self.jump(40)
                }
                
                print("released\(timePressed)")
            }
        }
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
            self.hero?.position.y = (self.hero?.size.height)! + 20
            
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Enemy) != 0)) {
            self.removeEnemy(secondBody.node as! SKSpriteNode)
            print("HIT AN ENEMY")
        }
    }
    
    //MARK:- Game actions
    func removeEnemy(enemy:SKSpriteNode){
        enemy.removeFromParent()
    }
    
    func updateEnemy(enemy:SKNode){
        
        if enemy.position.y < 0 {
            
            enemy.removeFromParent()
            numOfPoints += 1
            
            print("NUMBER OF POINTS \(numOfPoints)")
        }
    }

    
}
