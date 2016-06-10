//
//  GameScene.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 09/06/16.
//  Copyright (c) 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import SpriteKit
import VirtualGameController

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
    
    //Life cycle view
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.createHero()
        self.createCrosshair()
        //set the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //crosshair config
        self.crosshairMoviment(self.crosshair!)
        
        //set controller
        self.setControllersEvents()
        

    }
    
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
   
    //MARK: - Screen update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    //MARK: - Node creation Methods
    
    /**
     create a caracter to represent the hero
     */
    func createHero(){
        
        hero = SKSpriteNode(imageNamed: "Spaceship")
        hero!.xScale = 0.5
        hero!.yScale = 0.5
        hero!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        hero!.physicsBody = SKPhysicsBody(rectangleOfSize: hero!.size)
        hero!.physicsBody?.usesPreciseCollisionDetection = true
        hero!.physicsBody?.collisionBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair
        hero!.physicsBody?.categoryBitMask = PhysicsCategories.Hero
        hero!.physicsBody?.contactTestBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair
        hero!.name = "hero"
        self.addChild(hero!)

        
    }
    /**
     create a crosshair to guide the player jump  during the gameplay
     */
    func createCrosshair(){
        
        crosshair = SKSpriteNode(imageNamed: "Spaceship")
        crosshair!.xScale = 0.2
        crosshair!.yScale = 0.2
        crosshair!.position = CGPoint(x: CGRectGetMinX(hero!.frame)/50, y: CGRectGetMinY(hero!.frame))
        crosshair!.physicsBody = SKPhysicsBody(rectangleOfSize: crosshair!.size)
        crosshair!.physicsBody?.usesPreciseCollisionDetection = true
        crosshair!.physicsBody?.categoryBitMask = PhysicsCategories.Crosshair
        crosshair!.physicsBody?.collisionBitMask = PhysicsCategories.Crosshair | PhysicsCategories.Hero
        crosshair!.physicsBody?.dynamic = true
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
        node.runAction(action)
        
        
        
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
        
        func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
            for item in presses {
                if item.type == .Select {
                    //self.view.backgroundColor = UIColor.greenColor()
                    print("btn Pressed")
                    self.hero!.removeFromParent()
                }
            }
        }
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapped(_:)))
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)];
        self.view!.addGestureRecognizer(tapRecognizer)

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

    
}
