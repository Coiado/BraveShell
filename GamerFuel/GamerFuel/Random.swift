//
//  Random.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit


class Rand {
    
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

    
}