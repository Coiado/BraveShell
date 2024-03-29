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
    let playButtonTex = SKTexture(imageNamed: "play_button")
    var gScene:GameScene?
    

    var titleLabel: SKLabelNode?
    var newGameLabel:SKLabelNode?
    var bcImage:SKSpriteNode?
    var logo:SKSpriteNode?
    var backgroundMusic: SKAudioNode!
    
    override func didMoveToView(view: SKView) {
        
        bcImage = SKSpriteNode(imageNamed: "background")
        
        
        bcImage!.position = CGPointMake(self.size.width/2, self.size.height/2);
        self.addChild(bcImage!)
        
        self.logo = SKSpriteNode(imageNamed: "logo")
        self.logo?.xScale = 2.5
        self.logo?.yScale = 2.5
        self.logo?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(logo!)
        
        self.backgroundColor = UIColor.whiteColor()
    
        
        self.titleLabel = SKLabelNode(fontNamed: "Brandley Hand")
        self.newGameLabel = SKLabelNode(fontNamed: "Arial")
        
        self.titleLabel?.fontSize = 36
        self.newGameLabel?.fontSize = 22
        
        self.titleLabel?.fontColor = UIColor.blackColor()
        self.newGameLabel?.fontColor = UIColor.whiteColor()
        
        self.titleLabel?.text = "The Brave Shell"
        self.newGameLabel?.text = "new game"
        
        let backgroundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("somstart", ofType: "mp3")!)
        backgroundMusic = SKAudioNode(URL: backgroundURL)
        addChild(backgroundMusic)
        
        //self.titleLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!) ,y:CGRectGetMidY((self.scene?.frame)!) - (playButton.frame.height))
        //self.titleLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!) ,y:CGRectGetMidY((self.scene?.frame)!))
        //self.newGameLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!),y: CGRectGetMidY((self.scene?.frame)!) - (titleLabel?.frame.height)!)
        
        
        //self.addChild(titleLabel!)
        //self.addChild(newGameLabel!)
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!),y: CGRectGetMidY((self.scene?.frame)!) - (logo?.frame.height)! - 10)
        self.playButton.xScale = 1.5
        self.playButton.yScale = 1.5
        self.playButton.color = UIColor.blueColor()
        self.addChild(playButton)

        
    }
    
    func createScene(scene:GameScene){
        self.gScene = scene
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        if let touch = touches.first  {
//            let pos = touch.locationInNode(self)
//            let node = self.nodeAtPoint(pos)
//            
//            if node == playButton {
//                if let view = self.view {
//                    //let scene = GameScene(fileNamed: "GameScene")
//                    
//                    gScene!.scaleMode = .AspectFit
//                    gScene?.size.width = 1280
//                    gScene?.size.height = 720
//
//                    gScene!.scaleMode = SKSceneScaleMode.AspectFill
//                    view.presentScene(gScene)
//                }
//            }
//        }

        
        
//        
//        let timer = NSTimer(timeInterval: 1, target: self, selector: #selector(resizeButton), userInfo: nil, repeats: false)
//        timer.fire()
        
        playButton.runAction(SKAction.sequence([SKAction.scaleXTo(2.0, y: 2.0, duration: 0.2), SKAction.scaleXTo(1.5, y: 1.5, duration: 0.2)])) {
            self.createView()

        }
       
        
    
        
        self.resizeButton()
       
        
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        //super.pressesBegan(presses, withEvent: event)
        gScene!.pressesBegan(presses, withEvent: event)

    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        //super.pressesEnded(presses, withEvent: event)
        gScene?.pressesEnded(presses, withEvent: event)
    }
    
    
    func createView(){
        if let view = self.view {
            //let scene = GameScene(fileNamed: "GameScene")
            
            gScene!.scaleMode = .AspectFit
            gScene?.size.width = 1280
            gScene?.size.height = 720
            gScene!.scaleMode = SKSceneScaleMode.AspectFill
            view.presentScene(gScene)
        }

    }
    
    
    func resizeButton(){
        self.playButton.xScale = 2.0
        self.playButton.yScale = 2.0
//        self.playButton.xScale = 1.5
//        self.playButton.yScale = 1.5
    }
    
    func resizeLessButton(){
        self.playButton.xScale = 1.5
        self.playButton.yScale = 1.5
    }
    
    
    
    
}

