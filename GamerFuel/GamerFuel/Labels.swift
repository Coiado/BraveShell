//
//  Labels.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class Labels {
    
    func createHealthLabel(healthLabel:SKLabelNode, scene:SKScene, health: Int) {
        healthLabel.fontColor = UIColor.purpleColor()
        healthLabel.text = "HEALTH: \(health)"
        healthLabel.position = CGPointMake(scene.frame.width * 0.9, scene.frame.height * 0.95)
        healthLabel.fontSize = 20
        scene.addChild(healthLabel)
    }
    
    
    func createBoostLabel (boostLbl:SKLabelNode, scene:SKScene, avaliableImpulse:Int){
        boostLbl.fontColor = UIColor.purpleColor()
        boostLbl.text = "BOOSTS: \(avaliableImpulse)"
        boostLbl.position = CGPointMake(scene.frame.width * 0.9, scene.frame.height * 0.90)
        boostLbl.fontSize = 20
        scene.addChild(boostLbl)
        
    }
    
    func createPointsLabel(pointsLbl:SKLabelNode, scene:SKScene, numOfPoints:Int){
        pointsLbl.fontColor = UIColor.purpleColor()
        pointsLbl.text = "POINTS: \(numOfPoints)"
        pointsLbl.position = CGPointMake(scene.frame.width * 0.1, scene.frame.height * 0.95)
        pointsLbl.fontSize = 20
        scene.addChild(pointsLbl)
    }
    
    func createRecordLabel(recordLbl:SKLabelNode, scene:SKScene, recordPoints:Int){
        
        recordLbl.fontColor = UIColor.purpleColor()
        recordLbl.text = "RECORD: \(recordPoints)"
        recordLbl.position = CGPointMake(scene.frame.width * 0.1, scene.frame.height * 0.90)
        recordLbl.fontSize = 20
        scene.addChild(recordLbl)

    }
    
    
}