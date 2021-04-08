//
//  MainMenu.swift
//  Curves2
//
//  Created by Moritz Martin on 07.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    let p1Color = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p2Color = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p3Color = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 20)
    let p4Color = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 20)
    
    let startBtn = SKShapeNode(rectOf: CGSize(width: 120, height: 60), cornerRadius: 20)
    let addBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 20)
    let removeBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 20)
    
    
    var editedSettings: Bool = false
    
    var playerCount = 2
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        
        playerCount = 2
        
        
        startBtn.position = CGPoint (x: view.frame.width / 2, y: view.frame.height / 2)
        startBtn.fillColor = UIColor.blue
        addBtn.position = CGPoint(x: (view.frame.width / 2) + 140, y: view.frame.height / 2)
        addBtn.fillColor = UIColor.blue
        removeBtn.position = CGPoint(x: (view.frame.width / 2) - 140, y: view.frame.height / 2)
        removeBtn.fillColor = UIColor.blue
        
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
    
    func changeColor(_ number: Int){
        var randomColors = [UIColor.blue,UIColor.brown, UIColor.cyan, UIColor.green, UIColor.gray, UIColor.orange, UIColor.red, UIColor.purple, UIColor.yellow, UIColor.white]
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

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if addBtn.contains(location){
                
            }
            if removeBtn.contains(location){
                
            }
            if startBtn.contains(location){
                
            }
            if p1Color.contains(location){
                
            }
            if p2Color.contains(location){
                
            }
            if p3Color.contains(location){
                
            }
            if p4Color.contains(location){
                
            }
        }
            
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
