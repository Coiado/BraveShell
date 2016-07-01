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
    var backgroundMusic: SKAudioNode!
    var minionEagleSound: SKAudioNode!
    
    var healthLbl:SKLabelNode?
    var pointsLbl:SKLabelNode?
    var gameOverLabel:SKLabelNode?
    var restartLbl:SKLabelNode?
    var recordLbl:SKLabelNode?
    var boostLbl:SKLabelNode?
    var gameOverScreen:SKSpriteNode?
    
    var health = 100
    
    var gameOver = false
    var isJumping = false
    var enemyContact = false
    var hitTheFloor = true
    var isPressed = false
    var bossIsPresent = false
    
    var timer:NSTimer?
    var addEnemyTimer:NSTimer?
    
    var numOfPoints:Int = 0
    var bossHealth = 0
    var avaliableImpulse = 3
    var recordPoints = 0
    
    let heroClass = Hero()
    let backgroundClass = Background()
    let crosshairClass = Crosshair()
    let enemy = Enemy()
    let act = Actions()
    let labels = Labels()
    let gameAct  = GameActions()
    let heroAct = HeroActions()
    let worldPhysic = WorldPhysic()
    
    var xValueInitial:Float?
    var yValueInitial:Float?
    
    var xValueFinal:Float?
    var yValueFinal:Float?
    
    
    var controller:[GCController]?
    var validControler:GCController?
    
    
    //Life cycle view
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //setup the controller
        controller = GCController.controllers()
        validControler = controller![0]
        //validControler?.microGamepad?.allowsRotation = true
        
        hero = SKSpriteNode(imageNamed: "fulero_idle.1")
        background = SKSpriteNode(imageNamed: "background")
        crosshair = SKSpriteNode(imageNamed: "crosshair_arrow")
        
        backgroundClass.createBackground(background!, scene: self)
        heroClass.createHero(hero!, scene: self)
        crosshairClass.createCrosshair(crosshair!, hero: hero!)
        
        
        healthLbl = SKLabelNode(fontNamed: "Futura")
        labels.createHealthLabel(healthLbl!, scene: self, health: health)
        
        
        self.boostLbl = SKLabelNode(fontNamed: "Futura")
        labels.createBoostLabel(self.boostLbl!,scene: self, avaliableImpulse: avaliableImpulse)
        
        self.pointsLbl = SKLabelNode(fontNamed: "Futura")
        labels.createPointsLabel(self.pointsLbl!, scene: self, numOfPoints:numOfPoints)
        
        self.recordLbl = SKLabelNode(fontNamed: "Futura")
        
        labels.createRecordLabel(self.recordLbl!, scene:self, recordPoints:recordPoints)
        
        gameAct.loadRecord(self.recordLbl!, recordPoints: self.recordPoints)


        let backgroundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("somjogo", ofType: "mp3")!)
        backgroundMusic = SKAudioNode(URL: backgroundURL)
        addChild(backgroundMusic)
        
        
        //set the physics world
        self.physicsWorld.contactDelegate = self
        self.worldPhysic.setWorldPhysic(self)
        
    
        
        //crosshair config
        //gameAct.crosshairMoviment(self.crosshair!)
        
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.enemy.addEnemy(self)}),
                SKAction.waitForDuration(4.0)
                ])
            ), withKey: "addEnemy")
        
        addEnemyTimer?.fire()
        
        
        //controller.microGamepad?.allowsRotation = true
    }
    
    
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        

        
        if gameOver{
            self.restartTheGame()
        }else{
            xValueInitial = validControler!.microGamepad?.dpad.xAxis.value
            yValueInitial = validControler!.microGamepad?.dpad.yAxis.value
            
            print("x initial value \(xValueInitial) ,Y initial value \(yValueInitial)")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        xValueFinal = validControler!.microGamepad?.dpad.xAxis.value
        yValueFinal = validControler!.microGamepad?.dpad.yAxis.value
        
        print("x Final value \(xValueFinal) ,Y Final value \(yValueFinal)")
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        crosshair?.zRotation = CGFloat(((validControler?.microGamepad?.dpad.xAxis.value)! * (-1)))
    }
   
    //MARK: - Screen update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
         if numOfPoints % 20 == 0 && numOfPoints > 0 && bossIsPresent != true {
            bossIsPresent = true
            bossEnemy = SKSpriteNode(imageNamed: "mighty_eagle")
            enemy.addBoss(bossEnemy!, scene: self)
        }
        
        if bossIsPresent {
            updateBoss()
        }
        
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            if enemy.position.y <= 0 {
                self.updateEnemy(enemy)
            }
        }
        gameAct.updatePoints(enemyContact, numOfPoints: numOfPoints, pointsLbl:pointsLbl!)

    }

    
    //Low level press events
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        super.pressesBegan(presses, withEvent: event)
        
        if gameOver == false {
            for item in presses {
                
                if item.type == .PlayPause{
                    //print("pressed")
                    self.startTime = NSDate()
                    crosshair?.removeAllActions()
                    
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(changeCrosshairScale), userInfo: nil, repeats: true)
                    timer?.fire()
                }
            }

        }else{
            self.timer?.invalidate()
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
                            
                            hitTheFloor = worldPhysic.adjustGravity(self)
                            self.isJumping = heroAct.jump(90, crosshair: crosshair!,hero: hero!, isJumping: isJumping, scene:self)

                        }else
                            if timePressed > 0.5 {

                                hitTheFloor = worldPhysic.adjustGravity(self)
                                self.isJumping = heroAct.jump(120, crosshair: crosshair!,hero: hero!, isJumping: isJumping, scene:self)
                                
                            }else {

                                hitTheFloor = worldPhysic.adjustGravity(self)
                                self.isJumping = heroAct.jump(60, crosshair: crosshair!,hero: hero!, isJumping: isJumping, scene:self)
                        }

                    }else if isJumping == true {
                        if avaliableImpulse > 0 {
                            heroAct.impulse(60, crosshair:crosshair!, hero:hero!, scene:self)
                            avaliableImpulse -= 1
                            self.boostLbl!.text = "BOOST: \(avaliableImpulse)"
                        }
                        
                    }
                    
                    self.crosshair?.zRotation = 0.0
                    self.crosshair?.zPosition = 0.0
                    //gameAct.crosshairMoviment(crosshair!)
                    timer?.invalidate()
                    
                }
            }
            
        }else{
            timer?.invalidate()
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
            self.isJumping = false
            gameAct.heroHitTheFloor(hero!, crosshair:crosshair!)
            self.hitTheFloor = true

            
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Enemy) != 0)) {
            
            
            if gameOver == false {
                numOfPoints  += 15
                recordPoints += 15
                enemyContact = true
                gameAct.heroHitEnemy(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode, scene: self)
            }else{
                gameAct.removeEnemy(secondBody.node as! SKSpriteNode)
            }
        }else if ((firstBody.categoryBitMask & PhysicsCategories.Hero) != 0 && ((secondBody.categoryBitMask & PhysicsCategories.Boss) != 0)){
            if (bossHealth > 0) {
                bossHealth -= 1
                act.emiterFromBossHit(bossEnemy!.position, scene: self)
                gameAct.hitBossLbl((bossEnemy?.position)!, scene:self)
                hero!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }else{
                self.numOfPoints += 30
                self.recordPoints += 30
                bossIsPresent = false
                gameAct.destroyBossEnemy(bossEnemy!, scene:self)
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock({self.enemy.addEnemy(self)}),
                        SKAction.waitForDuration(4.0)
                        ])
                    ), withKey: "addEnemy")

            }
        }
    }
    
    //MARK:- Game actions
    
    func updateEnemy(enemy:SKNode ){
        
        if enemy.frame.minY <= 90 {
            
            if gameOver == false {
                enemy.removeFromParent()
                health -= 10
                healthLbl!.text = "HEALTH: \(health)"
                
            }
            
            if health == 0 {
                enemy.removeFromParent()
                gameOver = true
                isGameOver()
                
            }
            
        }
    }

    
    func updateBoss(){
        if bossEnemy?.frame.minY <=  90 {
            if gameOver == false {
                act.explosion((self.bossEnemy?.position)!,scene: self)
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
                act.explosion((self.bossEnemy?.position)!, scene: self)
                bossEnemy?.removeFromParent()
                bossIsPresent = false
            }

            
        }
        
    }
        
    /**
     ends the game
     */
    func isGameOver(){
        self.gameOverScreen?.removeFromParent()

        self.gameOverLabel?.removeFromParent()
        self.restartLbl?.removeFromParent()
        
        self.gameOverScreen = SKSpriteNode(imageNamed: "gameover_background")
        self.gameOverScreen?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(gameOverScreen!)
        
        
        self.crosshair?.yScale = 0.9
        self.crosshair?.xScale = 0.9

        self.gameOver = true
        self.gameOverLabel = SKLabelNode(fontNamed: "Arial")
        self.gameOverLabel?.text = "SCORE \(recordPoints)"
        self.gameOverLabel?.position = CGPointMake(CGRectGetMidX(self.gameOverScreen!.frame), CGRectGetMidY(self.gameOverScreen!    .frame))
        self.gameOverLabel?.fontSize = 20
        self.addChild(gameOverLabel!)
        
//        self.restartLbl = SKLabelNode(fontNamed:"Arial")
//        self.restartLbl?.text = "Tap on D-pad to restart"
//        self.restartLbl?.fontSize = 20
//        self.restartLbl?.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)) - 20)
        
        if let rcrd = NSUserDefaults.standardUserDefaults().valueForKey("record") as? Int {
            if recordPoints >  rcrd {
                NSUserDefaults.standardUserDefaults().setInteger(recordPoints, forKey: "record")
            }
        }else {
             NSUserDefaults.standardUserDefaults().setInteger(recordPoints, forKey: "record")
        }
        
        
    }
    /**
     Restart all the stats of game
     */
    func restartTheGame(){
        self.gameOverScreen?.removeFromParent()

        self.gameOver = false
        self.health = 100
        self.numOfPoints = 0
        self.recordPoints = 0
        
        self.crosshair?.yScale = 0.9
        self.crosshair?.xScale = 0.9
        self.crosshair?.zRotation = 0.0
        self.crosshair?.zPosition = 0.0
        gameAct.crosshairMoviment(crosshair!)
        
        self.healthLbl?.text = "HEALTH: \(health)"
        self.gameOverLabel?.removeFromParent()
        self.restartLbl?.removeFromParent()
        gameAct.loadRecord(self.recordLbl!, recordPoints:self.recordPoints)
        
        //get all the nodes with the same type
        enumerateChildNodesWithName("enemy") { (enemy, _) in
            enemy.removeFromParent()
        }
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.enemy.addEnemy(self)}),
                SKAction.waitForDuration(4.0)
                ])
            ), withKey: "addEnemy")
    }
    
    
    func changeCrosshairScale(){
        let xScale = crosshair!.xScale
        let yScale = crosshair!.yScale
        
        if xScale < 2.0 {
            crosshair!.xScale = xScale + 0.1
            crosshair!.yScale = yScale + 0.1
            crosshair!.color = UIColor.redColor()
        }
    }

    


    
    

    

    
}
