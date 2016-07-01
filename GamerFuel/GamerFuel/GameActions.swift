//
//  GameActions.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 24/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import SpriteKit

class GameActions {
    
    //properties
    let act = Actions()
    

    func loadRecord (recordLbl:SKLabelNode, recordPoints:Int){
        
        if let rcrd = NSUserDefaults.standardUserDefaults().integerForKey("record") as? Int {
            recordLbl.text = "RECORD: \(rcrd)"
        }else {
            recordLbl.text = "RECORD: \(recordPoints)"
        }
    }
    
    
    func hitBossLbl(pos:CGPoint, scene:SKScene){
        let hitLabel = SKLabelNode(fontNamed: "Arial")
        hitLabel.fontColor = UIColor.blackColor()
        hitLabel.fontSize = 20
        hitLabel.position = pos
        hitLabel.text = "-1"
        scene.addChild(hitLabel)
        
        scene.runAction(SKAction.waitForDuration(2),completion:{hitLabel.removeFromParent()})
    }
    
    @objc
    func changeCrosshairScale(timer:NSTimer){
        let dict = timer.userInfo as! NSDictionary
        let xScale = (dict["crosshair"] as! SKSpriteNode).xScale
        let yScale = (dict["crosshair"] as! SKSpriteNode).yScale
        
        if xScale < 2.0 {
            (dict["crosshair"] as! SKSpriteNode).xScale = xScale + 0.1
            (dict["crosshair"] as! SKSpriteNode).yScale = yScale + 0.1
            (dict["crosshair"] as! SKSpriteNode).color = UIColor.redColor()
        }
    }
    
    
    //MARK - Crosshair movient
    func crosshairMoviment(node:SKSpriteNode){
        let firstMoviment = SKAction.rotateByAngle(CGFloat(-75  * M_PI / 180), duration: 1)
        let secondMoviment = SKAction.rotateByAngle(CGFloat((5 * M_PI / 6 )), duration: 1)
        let clockWiseMoviment = SKAction.rotateByAngle(CGFloat(-5 * M_PI / 6 ), duration: 1)
        let antiClockWiseMoviment = SKAction.rotateByAngle(CGFloat(5 * M_PI / 6), duration: 1)
        let action = SKAction.repeatActionForever(SKAction.sequence([clockWiseMoviment,antiClockWiseMoviment]))
        
        node.runAction(firstMoviment, withKey:"firstMoviment")
        node.runAction(secondMoviment, withKey: "secondMovimet")
        
        node.runAction(action,withKey:"crosshairAction")
        
    }
    
    //MARK:-Game actions
    func removeEnemy(enemy:SKSpriteNode){
        enemy.removeFromParent()
    }
    
    
    func updatePoints(enemyContact:Bool, numOfPoints:Int, pointsLbl:SKLabelNode){
        if enemyContact {
            pointsLbl.text = "POINTS: \(numOfPoints)"
        }
    }
    
    
    func heroHitTheFloor(hero:SKSpriteNode, crosshair:SKSpriteNode){
        hero.removeActionForKey("spinning")
        hero.texture = SKTexture(imageNamed: "fulero_idle.1")
        act.fuleroIdle(hero)
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        crosshair.hidden = false
        crosshair.yScale = 0.9
        crosshair.xScale = 0.9
    }
    
    func heroHitEnemy(hero:SKSpriteNode, enemy:SKSpriteNode, scene:SKScene){
            hero.removeActionForKey("spinning")
            hero.texture = SKTexture(imageNamed: "fulero_falling")
            act.explosion(enemy.position, scene: scene)
            self.removeEnemy(enemy)
            scene.runAction(SKAction.playSoundFileNamed("MinionEagleSound.wav", waitForCompletion: false))
    }
    
    func destroyBossEnemy(bossEnemy:SKSpriteNode, scene:SKScene){
        act.explosion(bossEnemy.position, scene: scene)
        bossEnemy.removeFromParent()
        scene.runAction(SKAction.playSoundFileNamed("MightEagleSound.wav", waitForCompletion: false))
    }
    
    


    
}