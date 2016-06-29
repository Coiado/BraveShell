//
//  HeroActions.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 29/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class HeroActions {
    //properties
    let act = Actions()
    
    /**
     Perform a jump in  scree
     
     - parameter yAxis: CGFloat
     */
    func jump(velocity:CGFloat, crosshair:SKSpriteNode,hero:SKSpriteNode, isJumping:Bool, scene:SKScene) -> Bool{
        let isJumping = true
        //print(crosshair!.zRotation)
        let direction = crosshair.zRotation - CGFloat(M_PI)/2
        
        act.emiterFromJump(hero.position, scene: scene)
    
        hero.physicsBody?.velocity = CGVector(dx: velocity * -cos(direction) * 10, dy: velocity * -sin(direction) * 10)
        
        let heroJ1 = SKTexture(imageNamed: "fulero_spining.1")
        heroJ1.filteringMode = SKTextureFilteringMode.Nearest
        let heroJ2 = SKTexture(imageNamed: "fulero_spining.2")
        heroJ2.filteringMode = SKTextureFilteringMode.Nearest
        let heroJ3 = SKTexture(imageNamed: "fulero_spining.3")
        heroJ3.filteringMode = SKTextureFilteringMode.Nearest
        let heroJ4 = SKTexture(imageNamed: "fulero_spining.4")
        heroJ4.filteringMode = SKTextureFilteringMode.Nearest
        let heroJ5 = SKTexture(imageNamed: "fulero_spining.5")
        heroJ5.filteringMode = SKTextureFilteringMode.Nearest
        let heroJ6 = SKTexture(imageNamed: "fulero_spining.6")
        heroJ6.filteringMode = SKTextureFilteringMode.Nearest
        
        let spinning = SKAction.repeatActionForever(SKAction.animateWithTextures([heroJ1,heroJ2,heroJ3,heroJ4,heroJ5,heroJ6], timePerFrame: 0.1))
        hero.runAction(spinning, withKey: "spinning")
        
        crosshair.hidden = true
        
        return isJumping
    }
    
    
    //MARK:- impulse action
    func impulse(velocity:CGFloat, crosshair:SKSpriteNode,hero:SKSpriteNode, scene:SKScene ){
        
        print(crosshair.zRotation)
        let direction = crosshair.zRotation - CGFloat(M_PI)/2
        
        act.emiterFromJump(hero.position, scene: scene)
        
        hero.physicsBody?.velocity = CGVector(dx:velocity * -cos(direction) * 10, dy: velocity * -sin(direction) * 10)
        
    }


}