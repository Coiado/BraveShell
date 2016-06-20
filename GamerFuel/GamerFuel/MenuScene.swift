//
//  MenuScene.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 16/06/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import SpriteKit


class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "PlayButton")
    var gScene:GameScene?

    
    
    var titleLabel: SKLabelNode?
    var newGameLabel:SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel = SKLabelNode(fontNamed: "Brandley Hand")
        self.newGameLabel = SKLabelNode(fontNamed: "Arial")
        
        self.titleLabel?.fontSize = 36
        self.newGameLabel?.fontSize = 22
        
        self.titleLabel?.fontColor = UIColor.blackColor()
        self.newGameLabel?.fontColor = UIColor.whiteColor()
        
        self.titleLabel?.text = "Tatus Adventure"
        self.newGameLabel?.text = "new game"
        
        self.titleLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!) ,y:CGRectGetMidY((self.scene?.frame)!) - (playButton.frame.height))
        //self.titleLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!) ,y:CGRectGetMidY((self.scene?.frame)!))
        //self.newGameLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!),y: CGRectGetMidY((self.scene?.frame)!) - (titleLabel?.frame.height)!)
        
        
        self.addChild(titleLabel!)
        //self.addChild(newGameLabel!)
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!),y: CGRectGetMidY((self.scene?.frame)!) - (titleLabel?.frame.height)!)
        self.playButton.xScale = 0.2
        self.playButton.yScale = 0.2
        self.playButton.color = UIColor.blueColor()
        self.addChild(playButton)
        
        
    }
    
    func createScene(scene:GameScene){
        self.gScene = scene
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first  {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            
            if node == playButton {
                if let view = self.view {
                    //let scene = GameScene(fileNamed: "GameScene")
                    
                    gScene!.scaleMode = .AspectFit
                    gScene?.size.width = 1280
                    gScene?.size.height = 720

                    gScene!.scaleMode = SKSceneScaleMode.AspectFill
                    view.presentScene(gScene)
                }
            }
        }

        
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    }
    
    
}

