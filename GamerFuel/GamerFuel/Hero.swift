//
//  Hero.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit




class Hero{
    let act = Actions()
    //MARK - creational methods
    func createHero(hero:SKSpriteNode, scene:SKScene){
        
        hero.xScale = 0.05
        hero.yScale = 0.05
        hero.position = CGPoint(x: CGRectGetMidX(scene.frame), y: (CGRectGetMinY(scene.frame) + CGRectGetMaxY(hero.frame) + 60  ) )
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: hero.size)
        hero.physicsBody?.usesPreciseCollisionDetection = true
        hero.physicsBody?.collisionBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero.physicsBody?.categoryBitMask = PhysicsCategories.Hero
        hero.physicsBody?.contactTestBitMask = PhysicsCategories.Hero | PhysicsCategories.Crosshair | PhysicsCategories.Enemy | PhysicsCategories.floor
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.friction = 0
        hero.physicsBody?.restitution = 0
        hero.physicsBody?.linearDamping = 0
        hero.physicsBody?.angularDamping = 0
        hero.physicsBody?.mass = 28
        hero.physicsBody?.affectedByGravity  = true
        hero.physicsBody?.dynamic = true
        hero.name = "hero"
        scene.addChild(hero)
        act.fuleroIdle(hero)

    }
    
}