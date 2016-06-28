//
//  GameScene.swift
//  Curves2
//
//  Created by Moritz Martin on 27.06.16.
//  Copyright (c) 2016 Moritz Martin. All rights reserved.dd
//

import SpriteKit

class GameScene: SKScene {
    
    
    //unten Links
    var p1R = SKShapeNode()
    var p1L = SKShapeNode()
    

    //oben Links
    
    var p2R = SKShapeNode()
    var p2L = SKShapeNode()
    
    //oben Rechts
    
    var p3R = SKShapeNode()
    var p3L = SKShapeNode()
    
    //unten rechts
    var p4R = SKShapeNode()
    var p4L = SKShapeNode()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        scaleMode = .ResizeFill
    
        
        let trianglePathP1L = CGPathCreateMutable()
        CGPathMoveToPoint(trianglePathP1L, nil, 5, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 105, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 5, 0)
        CGPathCloseSubpath(trianglePathP1L)
        
        //1 Unten Links
        p1L = SKShapeNode(path: trianglePathP1L)
        p1L.position = CGPoint(x: 0, y: 10)
        p1L.strokeColor = SKColor.blueColor()
        p1L.fillColor = SKColor.redColor()
        self.addChild(p1L)
        
        p1R = SKShapeNode(path: trianglePathP1L)
        p1R.position = CGPoint(x: 5 + 110, y: 105)
        p1R.strokeColor = SKColor.blueColor()
        p1R.fillColor = SKColor.redColor()
        p1R.zRotation = CGFloat(-M_PI_4)*4
        self.addChild(p1R)
        
        
        
        //2 Oben links
        p2R = SKShapeNode(path: trianglePathP1L)
        p2R.position = CGPoint(x: 105, y: view.frame.height - 115)
        p2R.strokeColor = SKColor.blueColor()
        p2R.zRotation = CGFloat(M_PI_2)
        p2R.fillColor = SKColor.greenColor()
        self.addChild(p2R)
        
        p2L = SKShapeNode(path: trianglePathP1L)
        p2L.position = CGPoint(x: 10, y: view.frame.height)
        p2L.strokeColor = SKColor.blueColor()
        p2L.zRotation = CGFloat(-M_PI_2)
        p2L.fillColor = SKColor.redColor()
        self.addChild(p2L)
        
        
        
        // 3 oben rechts
        p3R = SKShapeNode(path: trianglePathP1L)
        p3R.position = CGPoint(x:view.frame.width - 115, y: view.frame.height - 105)
        p3R.strokeColor = SKColor.blueColor()
        p3R.fillColor = SKColor.greenColor()
        self.addChild(p3R)
        
        
        p3L = SKShapeNode(path: trianglePathP1L)
        p3L.position = CGPoint(x: view.frame.width, y: view.frame.height - 10)
        p3L.strokeColor = SKColor.blueColor()
        p3L.zRotation = CGFloat(M_PI)
        p3L.fillColor = SKColor.redColor()
        self.addChild(p3L)
        
        
        
        // 4 unten
        p4L = SKShapeNode(path: trianglePathP1L)
        p4L.position = CGPoint(x: view.frame.width - 10 , y: 0)
        p4L.strokeColor = SKColor.blueColor()
        p4L.zRotation = CGFloat (M_PI_2)
        p4L.fillColor = SKColor.greenColor()
        self.addChild(p4L)
        
        
        p4R = SKShapeNode(path: trianglePathP1L)
        p4R.position = CGPoint(x: view.frame.width - 105 , y: 115)
        p4R.strokeColor = SKColor.blueColor()
        p4R.zRotation = CGFloat (-M_PI_2)
        p4R.fillColor = SKColor.greenColor()
        self.addChild(p4R)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       /* Called when a touch begins   jj*/
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if p1R.containsPoint(location){
                print("rechts")
                
            }
            else if p1L.containsPoint(location){
                print("links")
            }
            
            
            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}


//
//
//func createButtons(){
//    
//    
//    let trianglePathP1L = CGPathCreateMutable()
//    CGPathMoveToPoint(trianglePathP1L, nil, 1, 105)
//    CGPathAddLineToPoint(trianglePathP1L, nil, 100, 205)
//    CGPathAddLineToPoint(trianglePathP1L, nil, 1, 205)
//    CGPathCloseSubpath(trianglePathP1L)
//    
//    let p1L = SKShapeNode(path: trianglePathP1L)
//    p1L.strokeColor = SKColor.blueColor()
//    p1L.fillColor = SKColor.redColor()
//    self.addChild(p1L)
//    
//    
//    
//    let p1R = SKShapeNode(path: trianglePathP1L)
//    p1R.strokeColor = SKColor.blueColor()
//    p1R.fillColor = SKColor.redColor()
//    p1R.zRotation = CGFloat(-M_PI_4)*4
//    p1R.position = CGPoint(x: 100, y: 300)
//    self.addChild(p1R)
//}
