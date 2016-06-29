//
//  Actions.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class Actions{
    
    func fuleroIdle (hero:SKSpriteNode){
        let heroI1 = SKTexture(imageNamed: "fulero_idle.1")
        heroI1.filteringMode = SKTextureFilteringMode.Nearest
        let heroI2 = SKTexture(imageNamed: "fulero_idle.2")
        heroI2.filteringMode = SKTextureFilteringMode.Nearest
        let heroI3 = SKTexture(imageNamed: "fulero_idle.3")
        heroI3.filteringMode = SKTextureFilteringMode.Nearest
        let heroI4 = SKTexture(imageNamed: "fulero_idle.4")
        heroI4.filteringMode = SKTextureFilteringMode.Nearest
        let heroI5 = SKTexture(imageNamed: "fulero_idle.5")
        heroI5.filteringMode = SKTextureFilteringMode.Nearest
        let heroI6 = SKTexture(imageNamed: "fulero_idle.6")
        heroI6.filteringMode = SKTextureFilteringMode.Nearest
        
        let idle = SKAction.repeatActionForever(SKAction.animateWithTextures([heroI1,heroI2,heroI3,heroI4,heroI5,heroI6], timePerFrame: 0.2))
        hero.runAction(idle, withKey: "idle")
    }
    
    //EMITERS
    
    func explosion(pos: CGPoint, scene:SKScene) {
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode!.particlePosition = pos
        scene.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the explosion
        scene.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
        
    }
    
    func emiterFromJump(pos:CGPoint, scene:SKScene){
        let emitterNode = SKEmitterNode(fileNamed: "JumpSmoke.sks")
        emitterNode!.particlePosition = pos
        scene.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the jump
        scene.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
    }
    
    func emiterFromBossHit(pos:CGPoint, scene:SKScene){
        let emitterNode = SKEmitterNode(fileNamed: "BossHit.sks")
        emitterNode!.particlePosition = pos
        scene.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the jump
        scene.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
    }
    
    
    

    
}