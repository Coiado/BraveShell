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

    
    var titleLabel: SKLabelNode?
    var newGameLabel:SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        
        self.titleLabel = SKLabelNode(fontNamed: "Arial")
        self.newGameLabel = SKLabelNode(fontNamed: "Arial")
        
        self.titleLabel?.fontSize = 36
        self.newGameLabel?.fontSize = 22
        
        self.titleLabel?.fontColor = UIColor.blackColor()
        self.newGameLabel?.fontColor = UIColor.whiteColor()
        
        self.titleLabel?.text = "Tatus Adventure"
        self.newGameLabel?.text = "new game"
        
        self.titleLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!) ,y:CGRectGetMidY((self.scene?.frame)!))
        self.newGameLabel?.position = CGPoint(x: CGRectGetMidX((self.scene?.frame)!),y: CGRectGetMidY((self.scene?.frame)!) - (titleLabel?.frame.height)!)

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.startGame()

    }
    
    private func startGame() {
        let gameScene = GameScene(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(0.15)
        view!.presentScene(gameScene, transition: transition)
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        print("PRESS MENU")
    }
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        print("END PRESS MENU")
    }
}
