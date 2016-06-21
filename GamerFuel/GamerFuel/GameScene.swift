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
    static let Boss      :UInt32 = 0x1 << 2
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
    var bossEnemy:SKSpriteNode?
    var floor:SKSpriteNode?
    var startTime:NSDate?
    var endDate:NSDate?
    
    var healthLbl:SKLabelNode?
    var pointsLbl:SKLabelNode?
    var gameOverLabel:SKLabelNode?
    var restartLbl:SKLabelNode?
    var recordLbl:SKLabelNode?
    
    var health = 100
    
    var gameOver = false
    var isJumping = false
    var enemyContact = false
    var hitTheFloor = true
    var isPressed = false
    var bossIsPresent = false
    
    var timer:NSTimer?
    
    var numOfPoints:Int = 0
    var bossHealth = 0
    var avaliableImpulse = 2
    var recordPoints = 0
    
    //Life cycle view
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
  
        
        self.createBackground()
        
        self.healthLbl = SKLabelNode(fontNamed: "Arial")
        self.healthLbl?.fontColor = UIColor.blackColor()
        self.healthLbl?.text = "HEALTH: \(health)"
        self.healthLbl?.position = CGPointMake(self.frame.width * 0.9, self.frame.height * 0.95)
        self.healthLbl?.fontSize = 20
        self.addChild(healthLbl!)
        
        self.pointsLbl = SKLabelNode(fontNamed: "Arial")
        self.pointsLbl?.fontColor = UIColor.blackColor()
        self.pointsLbl?.text = "POINTS: \(numOfPoints)"
        self.pointsLbl?.position = CGPointMake(self.frame.width * 0.1, self.frame.height * 0.95)
        self.pointsLbl?.fontSize = 20
        self.addChild(pointsLbl!)
        
        self.recordLbl = SKLabelNode(fontNamed: "Arial")
        self.recordLbl?.fontColor = UIColor.blackColor()
        self.recordLbl?.text = "RECORD: \(recordPoints)"
        self.recordLbl?.position = CGPointMake(self.frame.width * 0.1, self.frame.height * 0.90)
        self.recordLbl?.fontSize = 20
        self.addChild(recordLbl!)
        
        self.loadRecord()

        
        
        self.createHero()
        self.createCrosshair()
        
        print(self.view?.frame.width)
        
        
        //set the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        //let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPointMake(0, 60), size: CGSize(width: 1280, height: 660)))
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
            ), withKey: "addEnemy")
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
        
        if numOfPoints % 20 == 0 && numOfPoints > 0 && bossIsPresent != true {
            self.addBoss()
        }
        
        if bossIsPresent {
            updateBoss()
        }
        
        
     
        
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            if enemy.position.y <= 0 {
                self.updateEnemy(enemy)
            }
        }
        self.updatePoints()
        
    }
    
    func createBackground(){
        background = SKSpriteNode(imageNamed: "background")
        background!.size.width = 1280
        background!.size.height = 720
        
        background!.position = CGPointMake(self.size.width/2, self.size.height/2);
        self.addChild(background!)
        print("BACKGROUND")
        
    }
    
    
    
    //MARK: - Node creation Methods
    
    /**
     create a caracter to represent the hero
     */
    func createHero(){
        
        hero = SKSpriteNode(imageNamed: "fulero_withoutborders.placeholder")
        hero!.xScale = 0.05
        hero!.yScale = 0.05
        hero!.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMinY(self.frame) + CGRectGetMaxY(hero!.frame) + 60  ) )
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
        
        self.crosshair = SKSpriteNode(imageNamed: "crosshair_arrow")
        crosshair!.xScale = 0.9
        crosshair!.yScale = 0.9
        crosshair!.position = CGPoint(x: hero!.frame.width * 0.5, y: hero!.frame.height * 15)
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
        //Add textures
        let enemy1 = SKTexture(imageNamed: "minion_eagle.1")
        enemy1.filteringMode = SKTextureFilteringMode.Nearest
        let enemy2 = SKTexture(imageNamed: "minion_eagle.2")
        enemy2.filteringMode = SKTextureFilteringMode.Nearest
        let enemy3 = SKTexture(imageNamed: "minion_eagle.3")
        enemy3.filteringMode = SKTextureFilteringMode.Nearest
        let enemy4 = SKTexture(imageNamed: "minion_eagle.4")
        enemy4.filteringMode = SKTextureFilteringMode.Nearest
        
        let flap = SKAction.repeatActionForever(SKAction.animateWithTextures([enemy1,enemy2,enemy3,enemy4,enemy3,enemy2,enemy1], timePerFrame: 0.2))



        
        let kCCHaloLowAngle : CGFloat  = (200.0 * 3.14) / 180.0;
        let kCCHaloHighAngle : CGFloat  = (340.0 * 3.14) / 180.0;
        let kCCHaloSpeed: CGFloat = 100.0;
        
        
        let enemy = SKSpriteNode(texture: enemy1)
        
         let direction : CGVector  = radiansToVector(randomInRange(kCCHaloLowAngle, high: kCCHaloHighAngle));
        
        enemy.physicsBody?.velocity = CGVectorMake(direction.dx * kCCHaloSpeed, direction.dy * kCCHaloSpeed)
        
        enemy.xScale = 0.3
        enemy.yScale = 0.3
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        enemy.name = "enemy"
        
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.height - 90)
        
        
        //enemy.position = CGPointMake(random(min: enemy.size.width * 0.5, max: self.size.width - (enemy.size.width * 0.5)), self.size.height + (enemy.size.height * 0.5))
        enemy.position = CGPointMake(randomInRange(enemy.size.width * 0.5, high: self.size.width - (enemy.size.width * 0.5) - 60), self.size.height + (enemy.size.height * 0.5))
        addChild(enemy)
        
        let actualDuration = random(min: CGFloat(5), max: CGFloat(10.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -10), duration: NSTimeInterval(actualDuration))
        //let actionMoveDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove]))
        enemy.runAction(flap)

    }
    
    func addBoss(){
        
        
        let kCCHaloLowAngle : CGFloat  = (200.0 * 3.14) / 180.0;
        let kCCHaloHighAngle : CGFloat  = (340.0 * 3.14) / 180.0;
        let kCCHaloSpeed: CGFloat = 100.0;
        
        self.removeActionForKey("addEnemy")
        self.bossIsPresent = true
        bossEnemy = SKSpriteNode(imageNamed: "mighty_eagle")
        bossEnemy?.xScale = 0.3
        bossEnemy?.yScale = 0.3
        
        let direction : CGVector  = radiansToVector(randomInRange(kCCHaloLowAngle, high: kCCHaloHighAngle));
        
        bossEnemy!.physicsBody?.velocity = CGVectorMake(direction.dx * kCCHaloSpeed, direction.dy * kCCHaloSpeed)
        
        
        bossEnemy!.physicsBody = SKPhysicsBody(rectangleOfSize: bossEnemy!.size)
        bossEnemy!.physicsBody?.dynamic = false
        bossEnemy?.physicsBody?.allowsRotation = false
        bossEnemy?.physicsBody?.affectedByGravity = false
        bossEnemy!.physicsBody?.categoryBitMask = PhysicsCategories.Boss
        bossEnemy!.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        bossEnemy!.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        bossEnemy!.name = "enemy"
        bossHealth = 3
        
        let actualX = random(min: bossEnemy!.size.width/2, max: size.width - bossEnemy!.size.height)
        

        bossEnemy!.position = CGPointMake(randomInRange(bossEnemy!.size.width * 0.5, high: self.size.width - (bossEnemy!.size.width * 0.5)), self.size.height + (bossEnemy!.size.height * 0.5))
        addChild(bossEnemy!)
        
        let actualDuration = random(min: CGFloat(20), max: CGFloat(50))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -10), duration: NSTimeInterval(actualDuration))
        bossEnemy!.runAction(SKAction.sequence([actionMove]))

        

        
    
    }
    
    //MARK - Crosshair movient
    func crosshairMoviment(node:SKSpriteNode){
        let firstMoviment = SKAction.rotateByAngle(CGFloat(M_PI / 3), duration: 1)
        
        let clockWiseMoviment = SKAction.rotateByAngle(CGFloat((M_PI * 5) / 6 * -1), duration: 1)
        
        let antiClockWiseMoviment = SKAction.rotateByAngle(CGFloat((M_PI * 5) / 6), duration: 1)
    
        let action = SKAction.repeatActionForever(SKAction.sequence([clockWiseMoviment,antiClockWiseMoviment]))
        
        node.runAction(firstMoviment, withKey:"firstMovment")
        
        node.runAction(action,withKey:"crosshairAction")
        
        
    }
    

    
    
    
    //Low level press events
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        super.pressesBegan(presses, withEvent: event)

        if gameOver == false {
            for item in presses {
                
                if item.type == .PlayPause{
                    print("pressed")
                    self.startTime = NSDate()
                    crosshair?.removeAllActions()
                    
                    self.changeCrosshairScale()
                    
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(changeCrosshairScale), userInfo: nil, repeats: true)
                    timer?.fire()
                    
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
                            self.hitTheFloor = false
                            self.jump(90)

                        }else
                            if timePressed > 0.5 {
                                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                                self.hitTheFloor = false
                                self.jump(120)

                            }else {
                                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                                self.hitTheFloor = false
                                self.jump(60)
                        }

                    }else if isJumping == true {
                        if avaliableImpulse > 0 {
                            print("Impulsing")
                            self.impulse(60)
                            avaliableImpulse -= 1
                        }
                        
                        
                        
                    }
                    
                    print("released\(timePressed)")
                    self.crosshair?.zRotation = 0.0
                    self.crosshair?.zPosition = 0.0
                    
                    self.crosshairMoviment(crosshair!)
                    timer?.invalidate()
                    
                }
            }
            
        }

    }
    
    //MARK:- impulse action

    /**
     Perform a jump in  scree
     
     - parameter yAxis: CGFloat
     */
    func jump(velocity:CGFloat){
        isJumping = true
        print(crosshair!.zRotation)
        let direction = crosshair!.zRotation - CGFloat(M_PI)/2
        
        self.emiterFromJump(hero!.position)
        
        hero!.physicsBody?.velocity = CGVector(dx: velocity * -cos(direction) * 10, dy: velocity * -sin(direction) * 10)
        
        self.crosshair?.hidden = true

    }
    
    func impulse(velocity:CGFloat){
        
        print(crosshair!.zRotation)
        let direction = crosshair!.zRotation - CGFloat(M_PI)/2
        
        self.emiterFromJump(hero!.position)
        
        hero!.physicsBody?.velocity = CGVector(dx:0, dy: velocity * -sin(direction) * 10)

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
            hero!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.hitTheFloor = true
            self.crosshair?.hidden = false
            self.crosshair?.yScale = 0.9
            self.crosshair?.xScale = 0.9

            
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Enemy) != 0)) {
            
            print("HIT AN ENEMY")
            if gameOver == false{
                self.numOfPoints += 15
                self.recordPoints += 15
                self.enemyContact = true
                self.explosion((secondBody.node as! SKSpriteNode).position)
                self.removeEnemy(secondBody.node as! SKSpriteNode)

            }else{
                self.removeEnemy(secondBody.node as! SKSpriteNode)
            }
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Boss) != 0)){
            if (bossHealth > 0) {
                bossHealth -= 1
                self.hero!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }else{
                self.explosion((secondBody.node as! SKSpriteNode).position)
                bossEnemy!.removeFromParent()
                bossIsPresent = false
                self.numOfPoints += 30
                self.recordPoints += 30
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock(addEnemy),
                        SKAction.waitForDuration(4.0)
                        ])
                    ), withKey: "addEnemy")
            }
        }
    }
    
    //MARK:- Game actions
    func removeEnemy(enemy:SKSpriteNode){
        enemy.removeFromParent()
    }
    
    func updateEnemy(enemy:SKNode){
        
        if enemy.frame.minY <= 90 {
            
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
    
    func updateBoss(){
        if bossEnemy?.frame.minY <=  90 {
            if gameOver == false {
                self.explosion((self.bossEnemy?.position)!)
                
                bossEnemy?.removeFromParent()
                health -= 30
                if health > 0 {
                    self.healthLbl?.text = "HEALTH: \(health)"
                }else{
                    self.healthLbl?.text = "HEALTH: \(0)"
                    self.isGameOver()
                }
                bossIsPresent = false
            }else{
                self.explosion((self.bossEnemy?.position)!)
                bossEnemy?.removeFromParent()
                bossIsPresent = false
            }

            
            
        }
        
//        if bossEnemy?.position.y < 0 {
//            if gameOver == false {
//                self.explosion((self.bossEnemy?.position)!)
//
//                bossEnemy?.removeFromParent()
//                health -= 30
//                if health > 0 {
//                    self.healthLbl?.text = "HEALTH: \(health)"
//                }else{
//                    self.healthLbl?.text = "HEALTH: \(0)"
//                    self.isGameOver()
//                }
//                bossIsPresent = false
//            }
//        }
    }
    
    /**
     ends the game
     */
    func isGameOver(){
        self.gameOverLabel?.removeFromParent()
        self.restartLbl?.removeFromParent()

        self.gameOver = true
        self.gameOverLabel = SKLabelNode(fontNamed: "Arial")
        self.gameOverLabel?.text = " GAME OVER"
        self.gameOverLabel?.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.gameOverLabel?.fontSize = 20
        self.addChild(gameOverLabel!)
        
        self.restartLbl = SKLabelNode(fontNamed:"Arial")
        self.restartLbl?.text = "Tap on D-pad to restart"
        self.restartLbl?.fontSize = 20
        self.restartLbl?.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)) - 20)
        
        if let rcrd = NSUserDefaults.standardUserDefaults().valueForKey("record") as? Int {
            if recordPoints >  rcrd {
                NSUserDefaults.standardUserDefaults().setInteger(recordPoints, forKey: "record")
            }
        }else {
             NSUserDefaults.standardUserDefaults().setInteger(recordPoints, forKey: "record")
        }
        
        self.addChild(restartLbl!)
        
        
        

    }
    /**
     Restart all the stats of game
     */
    func restartTheGame(){
        self.gameOver = false
        self.health = 100
        self.numOfPoints = 0
        self.recordPoints = 0
        self.healthLbl?.text = "HEALTH: \(health)"
        self.gameOverLabel?.removeFromParent()
        self.restartLbl?.removeFromParent()
        self.loadRecord()
        
        //get all the nodes with the same type
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            enemy.removeFromParent()
        }
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(4.0)
                ])
            ), withKey: "addEnemy")

        
        
    }
    
    func explosion(pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode!.particlePosition = pos
        self.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
        
    }
    
    func emiterFromJump(pos:CGPoint){
        let emitterNode = SKEmitterNode(fileNamed: "JumpSmoke.sks")
        emitterNode!.particlePosition = pos
        self.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the jump
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
    }
    
    func changeCrosshairScale(){
        let xScale = crosshair!.xScale
        let yScale = crosshair!.yScale
        
        if xScale < 2.0 {
            crosshair?.xScale = xScale + 0.1
            crosshair?.yScale = yScale + 0.1
            crosshair?.color = UIColor.redColor()
        }
        
    }
    
    func loadRecord (){
        
        if let rcrd = NSUserDefaults.standardUserDefaults().integerForKey("record") as? Int {
            self.recordLbl?.text = "RECORD: \(rcrd)"
        }else {
            self.recordLbl?.text = "RECORD: \(recordPoints)"
        }
    }
    

    
    

    
}
