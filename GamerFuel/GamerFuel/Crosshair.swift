//
//  Crosshair.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class Crosshair {
    
    func createCrosshair(crosshair:SKSpriteNode, hero:SKSpriteNode){
        crosshair.xScale = 0.9
        crosshair.yScale = 0.9
        crosshair.position = CGPoint(x: hero.frame.width * 0.5, y: hero.frame.height * 15)
        crosshair.name = "small"
        hero.addChild(crosshair)
    }

}