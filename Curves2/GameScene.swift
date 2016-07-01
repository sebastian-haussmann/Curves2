//
//  GameScene.swift
//  Curves2
//
//  Created by Moritz Martin on 27.06.16.
//  Copyright (c) 2016 Moritz Martin. All rights reserved.dd
//

import SpriteKit


//Pysics Categories
struct PhysicsCat{
    static let gameAreaCat : UInt32 = 0x1 << 1
    static let itemCat : UInt32 = 0x1 << 2
    static let bombCat : UInt32 = 0x1 << 3
    static let p1HeadCat : UInt32 = 0x1 << 4
    static let p2HeadCat : UInt32 = 0x1 << 5
    static let p3HeadCat : UInt32 = 0x1 << 6
    static let p4HeadCat : UInt32 = 0x1 << 7
    static let p1tailCat : UInt32 = 0x1 << 8
    static let p2tailCat : UInt32 = 0x1 << 9
    static let p3tailCat : UInt32 = 0x1 << 10
    static let p4tailCat : UInt32 = 0x1 << 11
    
}

struct GameData{
    static var colors = [UIColor]()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var myTimerL1 = NSTimer()
    var myTimerR1 = NSTimer()
    
    var myTimerL2 = NSTimer()
    var myTimerR2 = NSTimer()

    var myTimerL3 = NSTimer()
    var myTimerR3 = NSTimer()
    
    var myTimerL4 = NSTimer()
    var myTimerR4 = NSTimer()
    
    var texture = SKTexture()
    var lineContainer = SKNode()
    var lineCanvas:SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        scaleMode = .ResizeFill
        
        physicsWorld.contactDelegate = self
        
        for (index,color) in GameData.colors.enumerate(){
            
            
            let line = LineObject(head: SKShapeNode(circleOfRadius: 3.0), position: CGPoint(), path: CGPathCreateMutable(), lineNode: SKShapeNode(), wayPoints: [], dead: false, lastPoint: CGPoint(), xCurve: CGFloat(1), yCurve: CGFloat(1), curveRadius: 5.0, curveSpeed: CGFloat(1))

            line.head.fillColor = color
            line.head.strokeColor = color
            line.lineNode.fillColor = color
            line.lineNode.strokeColor = color
            
            self.addChild(line.head)
            players.append(line)
            
        }
        newRound()
        
        createButtons(players.count)
        addPhysics()
        
        addChild(lineContainer)
        
        
        
        
        gameArea = SKShapeNode(rect: CGRect(x: btnWidth + 5 , y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
        gameArea.lineWidth = 5
        gameArea.strokeColor = SKColor.whiteColor()
        
        // Fügt den Wänden einen Body für die Kollisionserkennung hinzu
        gameArea.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: btnWidth + 5, y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
        gameArea.physicsBody!.categoryBitMask = PhysicsCat.gameAreaCat
        gameArea.physicsBody?.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
        gameArea.physicsBody?.affectedByGravity = false
        gameArea.physicsBody?.dynamic = false
        self.addChild(gameArea)
        
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       /* Called when a touch begins   jj*/
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if p1R.containsPoint(location){
                changeDirectionR2(0)
                myTimerR1 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 0, repeats: true)
                
            }else if p1L.containsPoint(location){
                changeDirectionL2(0)
                myTimerL1 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 0, repeats: true)
            }else if p2R.containsPoint(location){
                changeDirectionR2(1)
                myTimerR2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 1, repeats: true)
                
            }else if p2L.containsPoint(location){
                changeDirectionL2(1)
                myTimerL2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 1, repeats: true)
            }else if p3R.containsPoint(location){
                changeDirectionR2(2)
                myTimerR3 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 2, repeats: true)
                
            }
            else if p3L.containsPoint(location){
                changeDirectionL2(2)
                myTimerL3 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 2, repeats: true)
            }else if p4R.containsPoint(location){
                changeDirectionR2(3)
                myTimerR4 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 3, repeats: true)
                
            }else if p4L.containsPoint(location){
                changeDirectionL2(3)
                myTimerL4 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 3, repeats: true)
            }

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            
            
            if p1R.containsPoint(location) || p1L.containsPoint(location){
                myTimerR1.invalidate()
                myTimerL1.invalidate()
                
            }else if p2R.containsPoint(location) || p2L.containsPoint(location){
                myTimerR2.invalidate()
                myTimerL2.invalidate()
                
            }else if p3R.containsPoint(location) || p3L.containsPoint(location){
                myTimerR3.invalidate()
                myTimerL3.invalidate()
                
            }else if p4R.containsPoint(location) || p4L.containsPoint(location){
                myTimerR4.invalidate()
                myTimerL4.invalidate()
                
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            let prevLoc = touch.previousLocationInNode(self)
            
            if p1R.containsPoint(prevLoc) && !p1R.containsPoint(location) || p1L.containsPoint(prevLoc) && !p1L.containsPoint(location){
                myTimerR1.invalidate()
                myTimerL1.invalidate()
                
            }else if p2R.containsPoint(prevLoc) && !p2R.containsPoint(location) || p2L.containsPoint(prevLoc) && !p2L.containsPoint(location){
                myTimerR2.invalidate()
                myTimerL2.invalidate()
                
            }else if p3R.containsPoint(prevLoc) && !p3R.containsPoint(location) || p3L.containsPoint(prevLoc) && !p3L.containsPoint(location){
                myTimerR3.invalidate()
                myTimerL3.invalidate()
                
            }else if p4R.containsPoint(prevLoc) && !p4R.containsPoint(location) || p4L.containsPoint(prevLoc) && !p4L.containsPoint(location){
                myTimerR4.invalidate()
                myTimerL4.invalidate()
                
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
            if !player.dead{
                drawLine(i)
            }
        }
        
        
    }
    
    func drawLine(index: Int){
        if (CGPathIsEmpty(players[index].path)) {
            CGPathMoveToPoint(players[index].path, nil, players[index].lastPoint.x, players[index].lastPoint.y)
            players[index].lineNode.path = nil
            players[index].lineNode.lineWidth = 3.0
            
           
            
            lineContainer.addChild(players[index].lineNode)
            
            
        }
        
        var x = players[index].lastPoint.x + players[index].xCurve
        var y = players[index].lastPoint.y + players[index].yCurve
        CGPathAddLineToPoint(players[index].path, nil, x, y)
        players[index].lineNode.path = players[index].path
        players[index].head.position = CGPoint(x: x, y: y)
        
        
        players[index].lastPoint = CGPointMake(x, y)
        players[index].wayPoints.append(CGPoint(x:x,y:y))
        addLinesToTexture(index)
        addPhysicsTail(index)
        
    }
    

    func addLinesToTexture (index: Int) {
        // Convert the contents of the line container to an SKTexture
        texture = self.view!.textureFromNode(lineContainer)!
        lineCanvas!.texture = texture
        players[index].lineNode.removeFromParent()
        players[index].path = CGPathCreateMutable()
        
    }
    
    // setzt Spieler i auf zufällige Startposition
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

    // fügt Physics den Köpfen der Schlangen hinzu
    func addPhysics(){
        players[0].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
        players[0].head.physicsBody!.categoryBitMask = PhysicsCat.p1HeadCat
        players[0].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p2tailCat | PhysicsCat.p3tailCat | PhysicsCat.p4tailCat
        players[0].head.physicsBody?.affectedByGravity = false
        players[0].head.physicsBody?.linearDamping = 0
        
        if players.count > 1 {
            players[1].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
            players[1].head.physicsBody!.categoryBitMask = PhysicsCat.p2HeadCat
            players[1].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p3tailCat | PhysicsCat.p4tailCat
            players[1].head.physicsBody?.affectedByGravity = false
            players[1].head.physicsBody?.linearDamping = 0
        }
        if players.count > 2 {
            players[2].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
            players[2].head.physicsBody!.categoryBitMask = PhysicsCat.p3HeadCat
            players[2].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p2tailCat | PhysicsCat.p4tailCat
            players[2].head.physicsBody?.affectedByGravity = false
            players[2].head.physicsBody?.linearDamping = 0
        }
        if players.count > 3 {
            players[3].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
            players[3].head.physicsBody!.categoryBitMask = PhysicsCat.p4HeadCat
            players[3].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p2tailCat | PhysicsCat.p3tailCat
            players[3].head.physicsBody?.affectedByGravity = false
            players[3].head.physicsBody?.linearDamping = 0
        }
    }
    
    // fügt Physics den Tails der Schlangen hinzu, funktioniert leider noch nicht
    func addPhysicsTail(i: Int){
        
        let pBody = SKPhysicsBody(edgeChainFromPath: players[i].path)
        switch i {
        case 0:
            pBody.categoryBitMask = PhysicsCat.p1tailCat
            pBody.contactTestBitMask = PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
        case 1:
            pBody.categoryBitMask = PhysicsCat.p2tailCat
            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
        case 2:
            pBody.categoryBitMask = PhysicsCat.p3tailCat
            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p4HeadCat
        case 3:
            pBody.categoryBitMask = PhysicsCat.p4tailCat
            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat
        default:
            print("default")
        }
        pBody.affectedByGravity = false
        pBody.linearDamping = 0
//        players[i].lineNode.physicsBody = pBody
//        if players[i].lineNode.physicsBody != nil {
//            let bodies = SKPhysicsBody(bodies: [players[i].lineNode.physicsBody!, pBody])
//            players[i].lineNode.physicsBody = bodies
//        }else{
//            players[i].lineNode.physicsBody = pBody
//        }
    }
    
    
    func createButtons(playerCount: Int){
        
        
        CGPathMoveToPoint(trianglePathP1L, nil, 5, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 105, 100)
        CGPathAddLineToPoint(trianglePathP1L, nil, 5, 0)
        CGPathCloseSubpath(trianglePathP1L)
        
        
        // Für 1 und 2 Spieler
        if playerCount <= 2{
            p1L = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
            p1L.position = CGPoint(x: 50, y: 60 )
            p1L.strokeColor = GameData.colors[0]
            p1L.fillColor = GameData.colors[0]
            self.addChild(p1L)
            p1R = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
            p1R.position = CGPoint(x: view!.frame.width-50, y: 60)
            p1R.strokeColor = GameData.colors[0]
            p1R.fillColor = GameData.colors[0]
            self.addChild(p1R)
        }
    
        
        // Für genau 2. Spieler
        if playerCount == 2{            
            p2L = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
            p2L.position = CGPoint(x: view!.frame.width-50, y: view!.frame.height-50 )
            p2L.strokeColor = GameData.colors[1]
            p2L.fillColor = GameData.colors[1]
            self.addChild(p2L)
            p2R = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
            p2R.position = CGPoint(x: 50, y: view!.frame.height-50)
            p2R.strokeColor = GameData.colors[1]
            p2R.fillColor = GameData.colors[1]
            self.addChild(p2R)
        }
        
        
        // Buttons für 1.-3. Spieler
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
        // Buttons für 4. Spieler
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
    
    
    func newRound(){
        lineContainer.removeAllChildren()
        lineCanvas = SKSpriteNode(color:SKColor.clearColor(),size:view!.frame.size)
        lineCanvas!.anchorPoint = CGPointZero
        lineCanvas!.position = CGPointZero
        lineContainer.addChild(lineCanvas!)
        texture = SKTexture()
        for (index,player) in players.enumerate(){
//            addLinesToTexture(index)
            randomStartingPosition(index)
        }
        
    }

    
    // Kollisionen mit Wand und Tail der Gegner
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat) {
            players[0].dead = true
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat)  {
            players[1].dead = true
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat)  {
            players[2].dead = true
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat)  {
            players[3].dead = true
            
        }
    }
    
    
}
