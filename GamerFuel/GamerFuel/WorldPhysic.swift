//
//  WorldPhisic.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 01/07/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class WorldPhysic {
    
    /**
     set the initial physics condition of scene
     
     - parameter scene: SKScene
     */
    func setWorldPhysic(scene:SKScene){
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPointMake(0, 60), size: CGSize(width: 1280, height: 660)))
        borderBody.friction = 1
        borderBody.restitution = 0
        scene.physicsBody = borderBody
        scene.name = "edge"
    }
    
    /**
     the method sets the gravity valid on scene, and change the status 
     of the character
     
     - parameter scene: SKScene
     
     - returns: Bool
     */
    func adjustGravity(scene:SKScene) -> Bool{
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        return false
    }
}