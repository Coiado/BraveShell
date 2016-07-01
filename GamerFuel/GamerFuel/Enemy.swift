//
//  Enemy.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    
    let rand = Rand()
    
    
    
    
    /**
     add an enemy on the screen
     */
    @objc
    func addEnemy(scene:SKScene){
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
        
        let direction : CGVector  = rand.radiansToVector(rand.randomInRange(kCCHaloLowAngle, high: kCCHaloHighAngle));
        
        enemy.physicsBody?.velocity = CGVectorMake(direction.dx * kCCHaloSpeed, direction.dy * kCCHaloSpeed)
        
        enemy.xScale = 0.3
        enemy.yScale = 0.3
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        enemy.name = "enemy"
        
        let actualX = rand.random(min: enemy.size.width/2, max: scene.size.width - enemy.size.height - 90)
        enemy.position = CGPointMake(rand.randomInRange(enemy.size.width * 0.5, high: scene.size.width - (enemy.size.width * 0.5) - 60), scene.size.height + (enemy.size.height * 0.5))
        scene.addChild(enemy)
        
        let actualDuration = rand.random(min: CGFloat(5), max: CGFloat(10.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -10), duration: NSTimeInterval(actualDuration))
        enemy.runAction(SKAction.sequence([actionMove]))
        enemy.runAction(flap)
        
    }
    
    func addBoss(bossEnemy:SKSpriteNode, scene:SKScene){
        
        
        let kCCHaloLowAngle : CGFloat  = (200.0 * 3.14) / 180.0;
        let kCCHaloHighAngle : CGFloat  = (340.0 * 3.14) / 180.0;
        let kCCHaloSpeed: CGFloat = 100.0;
        
        scene.removeActionForKey("addEnemy")
        bossEnemy.xScale = 0.3
        bossEnemy.yScale = 0.3
        
        let direction : CGVector  = rand.radiansToVector(rand.randomInRange(kCCHaloLowAngle, high: kCCHaloHighAngle));
        bossEnemy.physicsBody?.velocity = CGVectorMake(direction.dx * kCCHaloSpeed, direction.dy * kCCHaloSpeed)
        bossEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: bossEnemy.size)
        bossEnemy.physicsBody?.dynamic = false
        bossEnemy.physicsBody?.allowsRotation = false
        bossEnemy.physicsBody?.affectedByGravity = false
        bossEnemy.physicsBody?.categoryBitMask = PhysicsCategories.Boss
        bossEnemy.physicsBody?.contactTestBitMask = PhysicsCategories.Hero
        bossEnemy.physicsBody?.collisionBitMask = PhysicsCategories.Hero
        bossEnemy.name = "enemy"
        let actualX = rand.random(min: bossEnemy.size.width/2, max: scene.size.width - bossEnemy.size.height)
        
        bossEnemy.position = CGPointMake(rand.randomInRange(bossEnemy.size.width * 0.5, high: scene.size.width - (bossEnemy.size.width * 0.5)), scene.size.height + (bossEnemy.size.height * 0.5))
        scene.addChild(bossEnemy)
        
        let actualDuration = rand.random(min: CGFloat(20), max: CGFloat(50))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -10), duration: NSTimeInterval(actualDuration))
        bossEnemy.runAction(SKAction.sequence([actionMove]))
        
        
    }

    
}