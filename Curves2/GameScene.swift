//
//  GameScene.swift
//  Curves2
//
//  Created by Moritz Martin on 27.06.16.
//  Copyright (c) 2016 Moritz Martin. All rights reserved.dd
//

import SpriteKit

struct GameData{
    static var colors = [UIColor]()
}

class GameScene: SKScene {
    
    let trianglePathP1L = CGPathCreateMutable()
    
    //unten Links
    var p1R = SKShapeNode()
    var p1L = SKShapeNode()
    var p2R = SKShapeNode()
    var p2L = SKShapeNode()
    var p3R = SKShapeNode()
    var p3L = SKShapeNode()
    var p4R = SKShapeNode()
    var p4L = SKShapeNode()
    
    
    var gameArea = SKShapeNode()
    var btnWidth: CGFloat = 110
    
    
    
    
    var players = [LineObject]()
    var myTimer1 = NSTimer()
    var myTimer2 = NSTimer()

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        scaleMode = .ResizeFill
        
        for (index,color) in GameData.colors.enumerate(){
            
            
            let line = LineObject(head: SKShapeNode(circleOfRadius: 3.0), position: CGPoint(), path: CGPathCreateMutable(), lineNode: SKShapeNode(), wayPoints: [], dead: false, lastPoint: CGPoint(), xCurve: CGFloat(1), yCurve: CGFloat(1), curveRadius: 5.0, curveSpeed: CGFloat(1))

            line.head.fillColor = color
            line.head.strokeColor = color
            line.lineNode.fillColor = color
            line.lineNode.strokeColor = color
            
            self.addChild(line.head)
            players.append(line)
            randomStartingPosition(index)
            
        }
        
        createButtons(players.count)
        
        
        
        
        gameArea = SKShapeNode(rect: CGRect(x: btnWidth + 5 , y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
        gameArea.lineWidth = 5
        gameArea.strokeColor = SKColor.whiteColor()
        self.addChild(gameArea)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       /* Called when a touch begins   jj*/
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if p1R.containsPoint(location){
                changeDirectionR2(0)
                myTimer1 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 0, repeats: true)
                
            }
            else if p1L.containsPoint(location){
                changeDirectionL2(0)
                myTimer2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 0, repeats: true)
            }
            

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        myTimer1.invalidate()
        myTimer2.invalidate()
        for touch in touches{
            let location = touch.locationInNode(self)
            
            if p1R.containsPoint(location){
                
            }
        }
        
        
    }
    
    //Linkskurve
    func changeDirectionL(timer: NSTimer){
        let playerIndex = timer.userInfo as! Int
        changeDirectionL2(playerIndex)
    }
    
    //Rechtskurve
    func changeDirectionR(timer: NSTimer){
        let playerIndex = timer.userInfo as! Int
        changeDirectionR2(playerIndex)
        
    }
    func changeDirectionL2(index: Int){
        let playerIndex = index
        print("hallo + ", index)
        let alt = pointToRadian(players[playerIndex].wayPoints[0])
        //        if switchDirBool {
        //           wayPoints[0] = radianToPoint(alt-curveRadius)
        //        }else{
        players[playerIndex].wayPoints[0] = radianToPoint(alt+players[playerIndex].curveRadius)
        //        }
        changeDirection(players[playerIndex].wayPoints[0], index: playerIndex)
    }
    
    //Rechtskurve
    func changeDirectionR2(index: Int){
        let playerIndex = index
        let alt = pointToRadian(players[playerIndex].wayPoints[0])
        //        if switchDirBool {
        //            wayPoints[0] = radianToPoint(alt+curveRadius)
        //        }else{
        players[playerIndex].wayPoints[0] = radianToPoint(alt-players[playerIndex].curveRadius)
        //        }
        changeDirection(players[playerIndex].wayPoints[0],index: playerIndex)
        
    }

    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        for (i,player) in players.enumerate(){
                drawLine(i)
        }
        
        
    }
    
    func drawLine(index: Int){
        
        var x = (players[index].lastPoint.x) + players[index].xCurve
        var y = (players[index].lastPoint.y) + players[index].yCurve

//        CGPathAddLineToPoint(path, nil, x, y)
//        lineNode.path = path
        players[index].head.position = CGPoint(x: x, y: y)
        players[index].lastPoint = CGPointMake(x, y)
        players[index].wayPoints.append(CGPoint(x:x,y:y))
        
    }
    
    
    func randomStartingPosition(i: Int){
        let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (4*btnWidth+10) - 100))) + 2 * btnWidth + 10 + 50
        let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 25)
        let startingPosition = CGPoint(x: posX, y: posY)
        //        print(startingPosition)
        
        players[i].head.position = CGPointMake(posX, posY)
        players[i].lastPoint = CGPointMake(posX, posY)
        players[i].wayPoints.append(startingPosition)
        
        let startingDirection = Double(arc4random_uniform(360))
        players[i].curveRadius = startingDirection
        changeDirectionL2(i)
        players[i].curveRadius = 5.0
    }

    
    
    func createButtons(playerCount: Int){
        
        
        CGPathMoveToPoint(trianglePathP1L, nil, 5, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 105, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 5, 0)
        CGPathCloseSubpath(trianglePathP1L)
        
        
        
        
        if playerCount == 2{
            //Ganz andere Anordnungg
        }
        
        
        if playerCount > 2 {
            
            p1L = SKShapeNode(path: trianglePathP1L)
            p1L.position = CGPoint(x: 0, y: 10)
            p1L.strokeColor = GameData.colors[0]
            p1L.fillColor = GameData.colors[0]
            self.addChild(p1L)
            
            p1R = SKShapeNode(path: trianglePathP1L)
            p1R.position = CGPoint(x: 5 + 110, y: 105)
            p1R.strokeColor = GameData.colors[0]
            p1R.fillColor = GameData.colors[0]
            p1R.zRotation = CGFloat(-M_PI_4)*4
            self.addChild(p1R)
            
            
            p3L = SKShapeNode(path: trianglePathP1L)
            p3L.position = CGPoint(x: view!.frame.width - 10 , y: 0)
            p3L.strokeColor = GameData.colors[2]
            p3L.zRotation = CGFloat (M_PI_2)
            p3L.fillColor = GameData.colors[2]
            self.addChild(p3L)
            
            p3R = SKShapeNode(path: trianglePathP1L)
            p3R.position = CGPoint(x: view!.frame.width - 105 , y: 115)
            p3R.strokeColor = GameData.colors[2]
            p3R.zRotation = CGFloat (-M_PI_2)
            p3R.fillColor = GameData.colors[2]
            p3R.alpha = 0.3
            self.addChild(p3R)
            
            
            p2R = SKShapeNode(path: trianglePathP1L)
            p2R.position = CGPoint(x:view!.frame.width - 115, y: view!.frame.height - 105)
            p2R.strokeColor = GameData.colors[1]
            p2R.fillColor = GameData.colors[1]
            self.addChild(p2R)
            
            p2L = SKShapeNode(path: trianglePathP1L)
            p2L.position = CGPoint(x: view!.frame.width, y: view!.frame.height - 10)
            p2L.strokeColor = GameData.colors[1]
            p2L.zRotation = CGFloat(M_PI)
            p2L.fillColor = GameData.colors[1]
            self.addChild(p2L)
            

            
        }
        if playerCount > 3 {
            

            p4R = SKShapeNode(path: trianglePathP1L)
            p4R.position = CGPoint(x: 105, y: view!.frame.height - 115)
            p4R.strokeColor = GameData.colors[3]
            p4R.zRotation = CGFloat(M_PI_2)
            p4R.fillColor = GameData.colors[3]
            self.addChild(p4R)
            
            p4L = SKShapeNode(path: trianglePathP1L)
            p4L.position = CGPoint(x: 10, y: view!.frame.height)
            p4L.strokeColor = GameData.colors[3]
            p4L.zRotation = CGFloat(-M_PI_2)
            p4L.fillColor = GameData.colors[3]
            self.addChild(p4L)
                        
        }
        
        
        
        
    }
    
    
    // Für Kurve -> Punkt zu Radius
    func pointToRadian(targetPoint: CGPoint) -> Double{
        let deltaX = targetPoint.x;
        let deltaY = targetPoint.y;
        let rad = atan2(deltaY, deltaX); // In radians
        return ( Double(rad) * (180 / M_PI))
    }
    
    //Für Kurve -> Radius zu Punkt
    func radianToPoint(rad: Double) -> CGPoint{
        return CGPoint(x: cos(rad*(M_PI/180))*141, y: sin(rad*(M_PI/180))*141)
    }
    
    
    
    //Für Kurve + Geschwindigkeit
    func changeDirection(targetPoint: CGPoint, index: Int){
        let currentPosition = position
        let offset = CGPoint(x: targetPoint.x - currentPosition.x, y: targetPoint.y - currentPosition.y)
        let length = Double(sqrtf(Float(offset.x * offset.x) + Float(offset.y * offset.y)))
        let direction = CGPoint(x:CGFloat(offset.x) / CGFloat(length), y: CGFloat(offset.y) / CGFloat(length))
        players[index].xCurve = direction.x * players[index].curveSpeed
        players[index].yCurve = direction.y * players[index].curveSpeed
        
        
    }

    
    
    
}
