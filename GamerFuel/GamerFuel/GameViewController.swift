//
//  GameViewController.swift
//  GamerFuel
//
//  Created by Evandro Henrique Couto de Paula on 09/06/16.
//  Copyright (c) 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let gameScene = GameScene(fileNamed: "GameScene")
    //var gameScene: GameScene?
    var menu:MenuScene?

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        //if let scene = GameScene(fileNamed: "GameScene") {
//            
//            // store game scene reference
//            //gameScene = scene
//            
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            gameScene!.scaleMode = .AspectFill
//        
//        
//            skView.presentScene(gameScene)
//        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()


        menu = MenuScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = false
        
        /* Set the scale mode to scale to fit the window */
        gameScene!.scaleMode = .AspectFit
        gameScene?.size.width = 1080
        gameScene?.size.height = 720


        
        skView.presentScene(gameScene)

    }

    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        gameScene!.pressesBegan(presses, withEvent: event)
        
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        gameScene!.pressesEnded(presses, withEvent: event)
    }
}
