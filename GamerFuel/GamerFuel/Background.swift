//
//  Background.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class Background {
    
    func createBackground(background:SKSpriteNode, scene:SKScene){
        background.size.width = 1280
        background.size.height = 720
        background.position = CGPointMake(scene.size.width/2, scene.size.height/2);
        scene.addChild(background)
        
    }

}