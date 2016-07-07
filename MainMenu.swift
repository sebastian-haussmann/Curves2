//
//  MainMenu.swift
//  Curves2
//
//  Created by Moritz Martin on 07.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    let p1Color = SKShapeNode(rectOfSize: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p2Color = SKShapeNode(rectOfSize: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p3Color = SKShapeNode(rectOfSize: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p4Color = SKShapeNode(rectOfSize: CGSize(width: 80, height: 80), cornerRadius: 20)
    
    let startBtn = SKShapeNode(rectOfSize: CGSize(width: 120, height: 60), cornerRadius: 20)
    let addBtn = SKShapeNode(rectOfSize: CGSize(width: 60, height: 60), cornerRadius: 20)
    let removeBtn = SKShapeNode(rectOfSize: CGSize(width: 60, height: 60), cornerRadius: 20)
    
    
    var editedSettings: Bool = false
    
    var playerCount = 2
    
    override func didMoveToView(view: SKView) {
        scaleMode = .ResizeFill
        
        playerCount = 2
        
        
        startBtn.position = CGPoint (x: view.frame.width / 2, y: view.frame.height / 2)
        startBtn.fillColor = UIColor.blueColor()
        addBtn.position = CGPoint(x: (view.frame.width / 2) + 140, y: view.frame.height / 2)
        addBtn.fillColor = UIColor.blueColor()
        removeBtn.position = CGPoint(x: (view.frame.width / 2) - 140, y: view.frame.height / 2)
        removeBtn.fillColor = UIColor.blueColor()
        
        self.addChild(startBtn)
        self.addChild(addBtn)
        self.addChild(removeBtn)
        
        p1Color.position = CGPoint(x: 80, y: 80)
        p2Color.position = CGPoint(x: view.frame.width - 80, y: view.frame.height - 80)
        p3Color.position = CGPoint(x: view.frame.width - 80, y: 80)
        p4Color.position = CGPoint(x: 80, y: view.frame.height - 80)
        self.addChild(p1Color)
        self.addChild(p2Color)
        self.addChild(p3Color)
        self.addChild(p4Color)
        
        for i in 0...3{
            changeColor(i)
        }
        
        
    }
    
    func changeColor(number: Int){
        var randomColors = [UIColor.blueColor(),UIColor.brownColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.grayColor(), UIColor.orangeColor(), UIColor.redColor(), UIColor.purpleColor(), UIColor.yellowColor(), UIColor.whiteColor()]
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p1Color.fillColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p2Color.fillColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p3Color.fillColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p4Color.fillColor
        }
        let colorInt = arc4random_uniform(UInt32(randomColors.count))
        switch number {
        case 0:
            p1Color.fillColor = randomColors[Int(colorInt)]
        case 1:
            p2Color.fillColor = randomColors[Int(colorInt)]
        case 2:
            p3Color.fillColor = randomColors[Int(colorInt)]
        case 3:
            p4Color.fillColor = randomColors[Int(colorInt)]
        default:
            print("Fail Color")
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if addBtn.containsPoint(location){
                
            }
            if removeBtn.containsPoint(location){
                
            }
            if startBtn.containsPoint(location){
                
            }
            if p1Color.containsPoint(location){
                
            }
            if p2Color.containsPoint(location){
                
            }
            if p3Color.containsPoint(location){
                
            }
            if p4Color.containsPoint(location){
                
            }
        }
            
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
