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
    static let p1HeadCat : UInt32 = 0x1 << 4
    static let p2HeadCat : UInt32 = 0x1 << 5
    static let p3HeadCat : UInt32 = 0x1 << 6
    static let p4HeadCat : UInt32 = 0x1 << 7
    static let tailCat : UInt32 = 0x1 << 8
    static let foodCat : UInt32 = 0x1 << 12
    static let p1TailCat : UInt32 = 0x1 << 13
    static let p2TailCat : UInt32 = 0x1 << 14
    static let p3TailCat : UInt32 = 0x1 << 15
    static let p4TailCat : UInt32 = 0x1 << 16
    static let bombCat : UInt32 = 0x1 << 17
    
}

struct GameData{
    static var colors = [UIColor]()
    static var gameModeID: Int = Int()
    static var gameModeCount: Int = Int()
    static var curveMode: Int = Int()
    static var settingsEdited: Bool = false
    static var singlePlayer: Bool = false
    static var singlePlayerVelocity: CGFloat = CGFloat()
    static var nickname: String = String()
    
}

class GameScene: SKScene, SKPhysicsContactDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let trianglePathP1L = CGMutablePath()
    
    //unten Links
    var p1R = SKShapeNode()
    var p1L = SKShapeNode()
    var p2R = SKShapeNode()
    var p2L = SKShapeNode()
    var p3R = SKShapeNode()
    var p3L = SKShapeNode()
    var p4R = SKShapeNode()
    var p4L = SKShapeNode()
    var counter = [Int]()
    
    var bomb = SKSpriteNode()
    var bombList = [SKSpriteNode]()
 
    var scoreLblList = [SKLabelNode]()
    
    
    
    var gameArea = SKShapeNode()
    var btnWidth: CGFloat = 110
    
    
    var players = [LineObject]()
    var foodList = [SKSpriteNode]()
    
    // Score
    var scoreView: UIView = UIView()
    var scoreTableView: UITableView = UITableView()
    var scoreSort = [(Int, UIColor, Int)]()   //Score, Color, Score in current Round
    var gameModeView: SKShapeNode = SKShapeNode()
    var gameModeLbl: SKLabelNode = SKLabelNode()
    
    
    var item = SKSpriteNode()
    var itemList = [SKSpriteNode]()
    var foodTimer = Timer()
    
    var waitTimer = Timer()
    
    var arrows = [SKSpriteNode]()
    
    // direction Timers
    var dir1 = Timer()
    var dir2 = Timer()
    var dir3 = Timer()
    var dir4 = Timer()
    
    var speedTimer = Timer()
    var thickTimer = Timer()
    
    var curRound = 0
    
    var endScreenView: SKShapeNode = SKShapeNode()
    var rematchBtn: SKShapeNode = SKShapeNode()
    var endGameBtn: SKShapeNode = SKShapeNode()
    var highScoreBtn: SKShapeNode = SKShapeNode()
    var endScreenLbl: SKLabelNode = SKLabelNode()
    var scoreName: UITextField = UITextField()
    
    var itemMultiply: CGFloat = 1.0
    var singlePlayerVelo: CGFloat = 1.0
    let pauseBtn = SKSpriteNode(imageNamed: "PauseBtn")
    let pauseBtn2 = SKSpriteNode(imageNamed: "PauseBtn")
    
    var gameCountTemp = 0
    var scalefactor = 1.0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
       
        scaleMode = .resizeFill
        physicsWorld.contactDelegate = self
        
        
        if self.view!.frame.maxY < 375{
            scalefactor = 0.8
        }
        
        pauseBtn.position = CGPoint(x: view.frame.width - (btnWidth / 2), y: view.frame.height / 2)
        pauseBtn.setScale(0.7*CGFloat(scalefactor))
        self.addChild(pauseBtn)
    
        pauseBtn2.position = CGPoint(x: btnWidth / 2, y: view.frame.height / 2)
        pauseBtn2.setScale(0.7*CGFloat(scalefactor))
        self.addChild(pauseBtn2)
        
        for (index,color) in GameData.colors.enumerated(){
            
            
            let line = LineObject(head: SKShapeNode(circleOfRadius: 8.0), position: CGPoint(), lineNode: SKShapeNode(), wayPoints: [], dead: true, lastPoint: CGPoint(), xSpeed: CGFloat(0), ySpeed: CGFloat(0), speed: CGFloat(1),tail: [], score: 0, snakeVelocity: CGFloat(2.0), changeDir: false)
        
            line.head.fillColor = color
            line.head.strokeColor = color
            line.lineNode.fillColor = color
            line.lineNode.strokeColor = color
            line.head.name = String(index)
            
            let arrow = SKSpriteNode(imageNamed: "EmptyArrow")
            arrow.setScale(0.05)
            arrow.isHidden = true
            arrows.append(arrow)
            self.addChild(arrow)
            
            let scorelbl = SKLabelNode(fontNamed: "TimesNewRoman")
            scorelbl.text = String(line.score)
            scorelbl.fontSize = 20
            scorelbl.fontColor = color
            scoreLblList.append(scorelbl)
            self.addChild(line.head)
            players.append(line)
            counter.append(0)
            
            
            if GameData.singlePlayer && index == 0{
                
                itemMultiply = 0.5 * GameData.singlePlayerVelocity
                players[0].snakeVelocity = 1.0 + (0.5 * GameData.singlePlayerVelocity)
                singlePlayerVelo = players[0].snakeVelocity
                
            }
            
        
            randomStartingPosition(index)
            waitTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(GameScene.waitBeforeStart), userInfo: 0, repeats: false)
            
            
            // Score View After each round
            scoreView = UIView(frame: CGRect(x: btnWidth + 5, y: 60, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
            scoreTableView = UITableView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10)))
            scoreView.addSubview(scoreTableView)
            scoreView.isHidden = true
            scoreTableView.dataSource = self
            scoreTableView.delegate = self
            scoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let tblView =  UIView(frame: CGRect.zero)
            scoreTableView.tableFooterView = tblView
            scoreTableView.tableFooterView!.isHidden = true
            scoreTableView.backgroundColor = UIColor.clear
            scoreTableView.allowsSelection = false
            scoreTableView.isScrollEnabled = false
            scoreSort.append((0,color,0))
            
            gameModeView = SKShapeNode(rect: CGRect(x: btnWidth + 5, y: 315, width: view.frame.width - (2*btnWidth+10), height: 55))
            gameModeView.isHidden = true
            gameModeView.fillColor = UIColor.black
            gameModeView.strokeColor = UIColor.white
            gameModeView.lineWidth = 2.0
            
            gameModeLbl = SKLabelNode(fontNamed: "Chalkduster")
            
           
                        
           
            
            
            if GameData.gameModeID == 0{
                gameModeLbl.text = "Ziel: " + String(GameData.gameModeCount)
            }else{
                gameModeLbl.text = "Runde " + String(curRound) + " von " + String(GameData.gameModeCount)
                
            }
            
            gameModeLbl.color = UIColor.white
            gameModeLbl.fontSize = 30
            gameModeLbl.position = CGPoint(x: view.frame.width / 2, y: view.frame.maxY - 45)
            gameModeView.addChild(gameModeLbl)
            
            self.addChild(gameModeView)
            self.view?.addSubview(scoreView)
            
            gameCountTemp = GameData.gameModeCount
            
        }
        
        createButtons(players.count)
        addPhysics()

            
            
        gameArea = SKShapeNode(rect: CGRect(x: btnWidth + 5 , y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
        gameArea.lineWidth = 5
        gameArea.strokeColor = SKColor.white
            
        // Fügt den Wänden einen Body für die Kollisionserkennung hinzu
        gameArea.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: btnWidth + 5, y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
        gameArea.physicsBody!.categoryBitMask = PhysicsCat.gameAreaCat
        gameArea.physicsBody?.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
        gameArea.physicsBody?.affectedByGravity = false
        gameArea.physicsBody?.isDynamic = false
        self.addChild(gameArea)
        
        foodTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameScene.createFood), userInfo: 0, repeats: true)
    }
    
    func makeEndScreen(_ singleOrMultiplayer: Int){
        
        foodTimer.invalidate()
        if !view!.scene!.isPaused{
            for item in itemList{
                item.removeFromParent()
            }
            for food in foodList{
                food.removeFromParent()
            }
            foodList = [SKSpriteNode]()

        }
        
        endScreenView = SKShapeNode(rect: CGRect(x: btnWidth + 5 + 10, y: 20, width: view!.frame.width - (2*btnWidth+10) - 20, height: view!.frame.height - 100))
        endScreenView.fillColor = UIColor.darkGray
        endScreenView.strokeColor = UIColor.white
        
        
        rematchBtn = SKShapeNode(rectOf: CGSize(width: 110, height: 60), cornerRadius: 20)
        endGameBtn = SKShapeNode(rectOf: CGSize(width: 110, height: 60), cornerRadius: 20)
        highScoreBtn = SKShapeNode(rectOf: CGSize(width: 110, height: 60), cornerRadius: 20)
        
        
        
        
        rematchBtn.fillColor = UIColor.blue
        highScoreBtn.fillColor = UIColor.blue
        endGameBtn.fillColor = UIColor.blue
        
        let rematchLbl = SKLabelNode(fontNamed: "TimesNewRoman")
        let endGameLbl = SKLabelNode(fontNamed: "TimesNewRoman")
        let highScoreLbl = SKLabelNode(fontNamed: "TimesNewRoman")
        
        endScreenLbl = SKLabelNode(fontNamed: "TimesNewRoman")
        endScreenLbl.position = CGPoint(x: view!.frame.width / 2, y: view!.frame.height / 2)
        if singleOrMultiplayer == 0{
            endScreenLbl.fontColor = GameData.colors[0]
            endScreenLbl.fontSize = 80
            endScreenLbl.text = String(players[0].score)
            rematchBtn.position = CGPoint(x: view!.center.x-130*CGFloat(scalefactor), y: 70)
            highScoreBtn.position = CGPoint(x: view!.center.x, y: 70)
            endGameBtn.position = CGPoint(x: view!.center.x+130*CGFloat(scalefactor), y: 70)
            rematchBtn.setScale(CGFloat(scalefactor))
            highScoreBtn.setScale(CGFloat(scalefactor))
            endGameBtn.setScale(CGFloat(scalefactor))
            highScoreBtn.alpha = 0.5
            highScoreBtn.addChild(highScoreLbl)
            endScreenView.addChild(highScoreBtn)
            scoreName = UITextField(frame: CGRect(x: view!.frame.width / 2 - 50, y: view!.frame.height/2 + 30, width: 100, height: 20))
            scoreName.attributedPlaceholder =  NSAttributedString(string: "Spielername", attributes: [NSAttributedString.Key.foregroundColor:GameData.colors[0]])
            scoreName.delegate = self
            scoreName.backgroundColor = UIColor.darkGray
            scoreName.textColor = GameData.colors[0]
            self.view?.addSubview(scoreName)
            let instruction = SKSpriteNode(imageNamed: "changeName")
            instruction.position = CGPoint(x: view!.frame.width / 2 + 120 , y: view!.frame.height / 2 - 80)
            endScreenView.addChild(instruction)
            //Data().saveSingleplayerHighscore(GameData.nickname, score: players[0].score)
        }else{
            endScreenLbl.fontColor = scoreSort[0].1
            endScreenLbl.fontSize = 25
            var playerName = ""
            for (count,player) in players.enumerated(){
                if GameData.colors[count] == scoreSort[0].1{
                    playerName = "Spieler " + String(count + 1)
                }
                
            }
            
            endScreenLbl.position = CGPoint(x: view!.frame.width / 2, y: view!.frame.height - 120)
            if view!.scene!.isPaused{
                endScreenLbl.text = "Pause"
                endScreenLbl.fontColor = UIColor.white
                endScreenLbl.fontSize = 85
                endScreenLbl.position = CGPoint(x: view!.frame.width / 2, y: (view!.frame.height / 2) - 20)

                
            }else{
                endScreenLbl.text = playerName + " gewinnt mit " + String(scoreSort[0].0) + " Punkten!"
            }
            rematchBtn.position = CGPoint(x: view!.center.x-70, y: 70)
            endGameBtn.position = CGPoint(x: view!.center.x+70, y: 70)
        }
        endScreenLbl.setScale(CGFloat(scalefactor))
        
        
        
        
        
        if view!.scene!.isPaused{
           rematchLbl.text = "Weiter"
        }else{
            rematchLbl.text = "Erneut Spielen"
        }
        
        rematchLbl.fontSize = 15
        endGameLbl.text = "Hauptmenü"
        endGameLbl.fontSize = 15
        highScoreLbl.text = "Highscore"
        highScoreLbl.fontSize = 15
        
        rematchBtn.addChild(rematchLbl)
        endGameBtn.addChild(endGameLbl)
        
        
        endScreenView.addChild(rematchBtn)
        endScreenView.addChild(endGameBtn)
        endScreenView.addChild(endScreenLbl)
        
       
        endScreenView.zPosition = 1
        self.addChild(endScreenView)
        
        
    
    }
    
    
    
    
    
    @objc func createFood(){
        let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (2*btnWidth + 10)))) + btnWidth + 5
        let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 10)

        let randFood = arc4random_uniform(17)
        var imageName = ""
        
        
        if randFood <= 2{
            imageName = "Banane"
        }else if randFood > 2 && randFood <= 8{
            imageName = "Apfel"
        }else{
            imageName = "Erdbeere"
        }
        
        let food = SKSpriteNode(imageNamed: imageName)
        food.name = imageName
        food.position = CGPoint(x: posX, y: posY)
        food.setScale(0.1)
        
        food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: food.size.width - 5, height: food.size.height - 5))
        //food.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: posX, y: posY, width: 10, height: 10))
        food.physicsBody!.categoryBitMask = PhysicsCat.foodCat
        food.physicsBody!.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = false
        food.physicsBody?.linearDamping = 0
        foodList.append(food)
        
        self.addChild(food)

        
        
    }
    
    func moveSnake(_ index : Int){
        if !players[index].dead {
            let x = players[index].lastPoint.x
            let y = players[index].lastPoint.y
            
            players[index].head.position = CGPoint(x: x + players[index].xSpeed, y: y + players[index].ySpeed)
            
           
            
            players[index].lastPoint = players[index].head.position
            players[index].wayPoints.append(players[index].lastPoint)
            
            if players[index].tail.count != 0{
                followHead(index)
            }
        }
    }
    
    
    func followHead(_ index: Int){
        
    
        var x  = Int(7.5)
        //var x = Int(15 / players[index].snakeVelocity)
        if GameData.singlePlayer{
            if GameData.singlePlayerVelocity == 1{
                x = 11
            }else{
                x = 12 - Int(1.75 * singlePlayerVelo)
            }
            
        }else{
            x = Int(8.5)
        }
        
        
        for tail in players[index].tail{
            let tailSize = players[index].wayPoints.count
            tail.position = players[index].wayPoints[tailSize - x]
            //x = x + Int(15 / players[index].snakeVelocity)
            if GameData.singlePlayer{
                if GameData.singlePlayerVelocity == 1{
                    x += 11
                }else{
                    x = x + 11 - Int(1.75 * singlePlayerVelo)
                }
               
            }else{
                x = x + Int(7.5)
            }
            
        }
        

    }

    
    @objc func newRound(){
        
        for bomb in bombList{
            bomb.removeFromParent()
        }
        bombList.removeAll()
        
        for food in foodList{
            food.removeFromParent()
        }
        foodList = [SKSpriteNode]()
        for item in itemList{
            item.removeFromParent()
        }
        itemList.removeAll()
        dir1.invalidate()
        dir2.invalidate()
        dir3.invalidate()
        dir4.invalidate()
        speedTimer.invalidate()
        thickTimer.invalidate()
        for (count,player) in players.enumerated(){
            for tail in players[count].tail{
                tail.removeFromParent()
            }
            player.head.xScale = 1
            player.head.yScale = player.head.xScale
            player.tail.removeAll()
            player.changeDir = false
            if GameData.singlePlayer{
                player.snakeVelocity = singlePlayerVelo
            }else{
                player.snakeVelocity = CGFloat(2.0)
            }
            randomStartingPosition(count)
            scoreSort[count].2 = 0
        }

        scoreView.isHidden = true
        gameModeView.isHidden = true
        waitTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameScene.waitBeforeStart), userInfo: 0, repeats: false)
        foodTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameScene.createFood), userInfo: 0, repeats: true)
        pauseBtn2.alpha = 1
        pauseBtn.alpha = 1
    }
    
    func randomStartingPosition(_ i: Int){
        let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (2 * btnWidth + 10) - 100))) + btnWidth + 5 + 50
        let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 25)
        let startingPosition = CGPoint(x: posX, y: posY)
                //        print(startingPosition)
        
        players[i].head.position = CGPoint(x: posX, y: posY)
        players[i].lastPoint = CGPoint(x: posX, y: posY)
        
        if players[i].wayPoints.count == 0{
            players[i].wayPoints.append(startingPosition)
        }else{
            players[i].wayPoints[0] = startingPosition
        }
        
        
        players[i].xSpeed = 1
        players[i].ySpeed = 0
        let rand = Int(arc4random_uniform(3))
        for _ in 0...rand {
            leftBtn(i)
        }
        arrows[i].isHidden = false
        arrows[i].position = CGPoint(x: posX,y: posY)
        
        arrows[i].zRotation = CGFloat((Double(90*rand)) * Double(M_PI/180))



    }

    func newGame(){
        
        curRound = 0
        GameData.gameModeCount = gameCountTemp
        
        for (count,player) in players.enumerated(){
            player.score = 0
            scoreSort[count].0 = 0
            scoreLblList[count].text = "0"
        }
        scoreName.removeFromSuperview()
        endScreenView.removeFromParent()
        self.view?.addSubview(scoreView)
        newRound()
        
    }
    
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
           /* Called when a touch begins */
    
            for touch in touches {
                let location = touch.location(in: self)
    
                if p1R.contains(location){
                    if !players[0].changeDir{
                        rightBtn(0)
                    }else{
                        leftBtn(0)
                    }
                    p1R.alpha = 0.5
                    
                }else if p1L.contains(location){
                    if !players[0].changeDir{
                        leftBtn(0)
                    }else{
                        rightBtn(0)
                    }
                    p1L.alpha = 0.5
                    
                }else if p2R.contains(location){
                    if !players[1].changeDir{
                        rightBtn(1)
                    }else{
                        leftBtn(1)
                    }
                    p2R.alpha = 0.5
                    
                }else if p2L.contains(location){
                    if !players[1].changeDir{
                        leftBtn(1)
                    }else{
                        rightBtn(1)
                    }
                    p2L.alpha = 0.5
                    
                }else if p3R.contains(location){
                    if !players[2].changeDir{
                        rightBtn(2)
                    }else{
                        leftBtn(2)
                    }
                    p3R.alpha = 0.5
                    
                }else if p3L.contains(location){
                    if !players[2].changeDir{
                        leftBtn(2)
                    }else{
                        rightBtn(2)
                    }
                    p3L.alpha = 0.5
                    
                }else if p4R.contains(location){
                    if !players[3].changeDir{
                        rightBtn(3)
                    }else{
                        leftBtn(3)
                    }
                    p4R.alpha = 0.5
                    
                }else if p4L.contains(location){
                    if !players[3].changeDir{
                        leftBtn(3)
                    }else{
                        rightBtn(3)
                    }
                    p4L.alpha = 0.5
                }else if rematchBtn.contains(location){
                    if view!.scene!.isPaused{
                       continueGame()
                    }else{
                        newGame()
                    }
                    rematchBtn.alpha = 0.5
                }else if highScoreBtn.contains(location) && !highScoreBtn.isHidden{
                    if scoreName.text! != "" {
                        highScoreBtn.isHidden = true
                        addHighscore(scoreName.text!)
//                        scoreView.removeFromSuperview()
//                        endScreenView.removeFromParent()
//                        scoreName.removeFromSuperview()
//                        scoreTableView.removeFromSuperview()
//                        self.removeAllActions()
//                        self.removeAllChildren()
//                        let scene = HighscoreScene(fileNamed: "HighscoreScene")
//            
//                        scene!.scaleMode = .ResizeFill
//                        
//                        self.view?.presentScene(scene!, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))

                    }
                    highScoreBtn.alpha = 0.5
                }else if endGameBtn.contains(location){
                    closeGame()
                    endGameBtn.alpha = 0.5
                }else if pauseBtn.contains(location) && pauseBtn.alpha == 1{
                    if view!.scene!.isPaused{
                        continueGame()
                    }else{
                        self.run(SKAction.run(self.pauseGame))
                    }
                    
                }
                else if pauseBtn2.contains(location) && pauseBtn2.alpha == 1{
                    if view!.scene!.isPaused{
                        continueGame()
                    }else{
                        self.run(SKAction.run(self.pauseGame))
                    }

                }
          }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if p1R.contains(location){
                p1R.alpha = 1
                
            }else if p1L.contains(location){
                p1L.alpha = 1
                
            }else if p2R.contains(location){
                p2R.alpha = 1
                
            }else if p2L.contains(location){
                p2L.alpha = 1
                
            }else if p3R.contains(location){
                p3R.alpha = 1
                
            }else if p3L.contains(location){
                p3L.alpha = 1
                
            }else if p4R.contains(location){
                p4R.alpha = 1
                
            }else if p4L.contains(location){
                p4L.alpha = 1
            }else if rematchBtn.contains(location){
                rematchBtn.alpha = 1
            }else if highScoreBtn.contains(location){
                if scoreName.text! != "" {
                    highScoreBtn.alpha = 1
                }else{
                    highScoreBtn.alpha = 0.5
                }
            }else if endGameBtn.contains(location){
                endGameBtn.alpha = 1
            }
        
        }

    }

    func pauseGame(){
        
        scene!.view!.isPaused = true
        makeEndScreen(1)
        
    }
    
    func continueGame(){
        scene!.view!.isPaused = false
        foodTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameSceneCurve.createFood), userInfo: 0, repeats: true)
        endScreenView.removeFromParent()
    }

    func rightBtn(_ index: Int){
        if(players[index].xSpeed > 0){
            players[index].xSpeed = 0
            players[index].ySpeed = -1 * players[index].snakeVelocity
        }else if (players[index].xSpeed < 0){
            players[index].xSpeed = 0
            players[index].ySpeed = 1 * players[index].snakeVelocity
        }else if (players[index].ySpeed < 0){
            players[index].xSpeed = -1 * players[index].snakeVelocity
            players[index].ySpeed = 0
        }else if (players[index].ySpeed > 0){
            players[index].xSpeed = 1 * players[index].snakeVelocity
            players[index].ySpeed = 0
        }
        
        for tail in players[index].tail{
            tail.zRotation = 0.0
        }
        
        
    }
    
    func leftBtn(_ index: Int){
        if(players[index].xSpeed > 0){
            players[index].xSpeed = 0
            players[index].ySpeed = 1 * players[index].snakeVelocity
        }else if (players[index].xSpeed < 0){
            players[index].xSpeed = 0
            players[index].ySpeed = -1 * players[index].snakeVelocity
        }else if (players[index].ySpeed < 0){
            players[index].xSpeed = 1 * players[index].snakeVelocity
            players[index].ySpeed = 0
        }else if (players[index].ySpeed > 0){
            players[index].xSpeed = -1 * players[index].snakeVelocity
            players[index].ySpeed = 0
        }
        for tail in players[index].tail{
            tail.zRotation = 0.0
        }
        
    }

    
    
    func makeItems(){
        let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (2*btnWidth + 10)))) + btnWidth + 5
        let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 10)
        
        var nameRandom = arc4random_uniform(9)
        
        var imageName = ""
        
//        if nameRandom < 5 {
//            imageName = "SpeedItemGreen"
//        }else 
//        if nameRandom >= 5 && players.count > 1{
//            imageName = "SpeedItemRed"
//        }
        let rand = Int(arc4random_uniform(5))
        switch rand {
        case 0:
            imageName = "SpeedItemGreen"
        case 1:
            if players.count > 1{
                imageName = "switchDirRed"
            }
        case 2:
            if players.count > 1{
                imageName = "SpeedItemRed"
            }
        case 3:
            if players.count > 1{
                imageName = "FatItemRed"
            }
        case 4:
            imageName = "bombItem"
        default:
            break
        }
        if imageName != "" {
            item = SKSpriteNode(imageNamed: imageName)
            item.name = imageName
            item.setScale(0.4)
            item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.height / 2)
            item.physicsBody!.categoryBitMask = PhysicsCat.itemCat
            item.physicsBody!.contactTestBitMask =  PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
            item.physicsBody?.affectedByGravity = false
            item.physicsBody?.linearDamping = 0
            item.physicsBody?.isDynamic = false
            item.position = CGPoint(x: posX, y: posY)
            
            if !(item.position == CGPoint(x: 0.0, y: 0.0)){
                addChild(item)
                itemList.append(item)
            }
        }
    }

    
    
    func createButtons(_ playerCount: Int){
    
            trianglePathP1L.move(to: CGPoint(x: 5, y: 100))
            trianglePathP1L.addLine(to: CGPoint(x: 105, y: 100))
            trianglePathP1L.addLine(to: CGPoint(x: 0, y: 0))
            trianglePathP1L.closeSubpath()
    
    
            // Für 1 und 2 Spieler
            if playerCount <= 2{
                
                let leftArr = SKSpriteNode(imageNamed: "LeftArr")
                let rightArr = SKSpriteNode(imageNamed: "RightArr")
                p1L = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                p1L.position = CGPoint(x: 50, y: 50 )
                p1L.strokeColor = GameData.colors[0]
                p1L.fillColor = GameData.colors[0]
                leftArr.setScale(0.5)
                leftArr.position = CGPoint(x: 0, y: 0)
                p1L.addChild(leftArr)
                
                self.addChild(p1L)
                p1R = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                p1R.position = CGPoint(x: view!.frame.width-50, y: 50)
                p1R.strokeColor = GameData.colors[0]
                p1R.fillColor = GameData.colors[0]
                rightArr.setScale(0.5)
                rightArr.position = CGPoint(x: 0, y: 0)
                p1R.addChild(rightArr)
                
                
                self.addChild(p1R)
                
                scoreLblList[0].position = CGPoint(x: 15, y: 120)
                self.addChild(scoreLblList[0])
                
                
                
            }
    
    
            // Für genau 2. Spieler
            if playerCount == 2{
                
                let leftArr = SKSpriteNode(imageNamed: "RightArr")
                let rightArr = SKSpriteNode(imageNamed: "LeftArr")
                p2L = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                p2L.position = CGPoint(x: view!.frame.width-50, y: view!.frame.height-50 )
                p2L.strokeColor = GameData.colors[1]
                p2L.fillColor = GameData.colors[1]
                leftArr.setScale(0.5)
                leftArr.position = CGPoint(x: 0, y: 0)
                p2L.addChild(leftArr)
                self.addChild(p2L)
                p2R = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                p2R.position = CGPoint(x: 50, y: view!.frame.height-50)
                p2R.strokeColor = GameData.colors[1]
                p2R.fillColor = GameData.colors[1]
                rightArr.setScale(0.5)
                rightArr.position = CGPoint(x: 0, y: 0)
                p2R.addChild(rightArr)
                self.addChild(p2R)
                
                scoreLblList[1].position = CGPoint(x: 15, y: view!.frame.height - 120)
                scoreLblList[1].zRotation = CGFloat(M_PI_2) * 2
                self.addChild(scoreLblList[1])
                
            }
    
    
            // Buttons für 1.-3. Spieler
            if playerCount > 2 {
                
                
                let leftArr = SKSpriteNode(imageNamed: "TopLeftArr")
                let rightArr = SKSpriteNode(imageNamed: "BottomRightArr")
                
                p1L = SKShapeNode(path: trianglePathP1L)
                p1L.position = CGPoint(x: 0, y: 10)
                p1L.strokeColor = GameData.colors[0]
                p1L.fillColor = GameData.colors[0]
                leftArr.setScale(0.3)
                leftArr.position = CGPoint(x: 38, y: 68)
                p1L.addChild(leftArr)
                self.addChild(p1L)
    
                p1R = SKShapeNode(path: trianglePathP1L)
                p1R.position = CGPoint(x: 5 + 110, y: 105)
                p1R.strokeColor = GameData.colors[0]
                p1R.fillColor = GameData.colors[0]
                p1R.zRotation = CGFloat(-M_PI_4)*4
                rightArr.setScale(0.3)
                rightArr.zRotation = CGFloat(-M_PI_4)*4
                rightArr.position = CGPoint(x: 38, y: 68)
                p1R.addChild(rightArr)
                self.addChild(p1R)
                
                scoreLblList[0].position = CGPoint(x: 15, y: 120)
                self.addChild(scoreLblList[0])
    
    
                let leftArr3 = SKSpriteNode(imageNamed: "TopRightArr")
                let rightArr3 = SKSpriteNode(imageNamed: "BottomLeftArr")
                
                p3L = SKShapeNode(path: trianglePathP1L)
                p3L.position = CGPoint(x: view!.frame.width - 10 , y: 0)
                p3L.strokeColor = GameData.colors[2]
                p3L.zRotation = CGFloat(M_PI_2)
                p3L.fillColor = GameData.colors[2]
                leftArr3.setScale(0.3)
                leftArr3.zRotation = CGFloat(M_PI_2)
                leftArr3.position = CGPoint(x: 38, y: 68)
                p3L.addChild(leftArr3)
                
                self.addChild(p3L)
    
                p3R = SKShapeNode(path: trianglePathP1L)
                p3R.position = CGPoint(x: view!.frame.width - 105 , y: 115)
                p3R.strokeColor = GameData.colors[2]
                p3R.zRotation = CGFloat (-M_PI_2)
                p3R.fillColor = GameData.colors[2]
                rightArr3.setScale(0.3)
                rightArr3.zRotation = CGFloat(-M_PI_2)
                rightArr3.position = CGPoint(x: 38, y: 68)
                p3R.addChild(rightArr3)
                self.addChild(p3R)
                
                
                scoreLblList[2].position = CGPoint(x: view!.frame.width - 15, y: 120)
                self.addChild(scoreLblList[2])
    
    
                let leftArr2 = SKSpriteNode(imageNamed: "BottomRightArr")
                let rightArr2 = SKSpriteNode(imageNamed: "TopLeftArr")
                
                p2R = SKShapeNode(path: trianglePathP1L)
                p2R.position = CGPoint(x:view!.frame.width - 115, y: view!.frame.height - 105)
                p2R.strokeColor = GameData.colors[1]
                p2R.fillColor = GameData.colors[1]
               
                rightArr2.setScale(0.3)
                rightArr2.position = CGPoint(x: 38, y: 68)
                p2R.addChild(rightArr2)
                
                self.addChild(p2R)
    
                p2L = SKShapeNode(path: trianglePathP1L)
                p2L.position = CGPoint(x: view!.frame.width, y: view!.frame.height - 10)
                p2L.strokeColor = GameData.colors[1]
                p2L.zRotation = CGFloat(M_PI)
                p2L.fillColor = GameData.colors[1]
                
                leftArr2.setScale(0.3)
                leftArr2.zRotation = CGFloat(M_PI)
                leftArr2.position = CGPoint(x: 38, y: 68)
                p2L.addChild(leftArr2)
                self.addChild(p2L)
                
                scoreLblList[1].position = CGPoint(x: view!.frame.width - 15, y: view!.frame.height - 120)
                scoreLblList[1].zRotation = CGFloat(M_PI_2) * 2
                self.addChild(scoreLblList[1])
    
    
    
            }
            // Buttons für 4. Spieler
            if playerCount > 3 {
    
                let leftArr = SKSpriteNode(imageNamed: "BottomLeftArr")
                let rightArr = SKSpriteNode(imageNamed: "TopLeftArr")
    
                p4R = SKShapeNode(path: trianglePathP1L)
                p4R.position = CGPoint(x: 105, y: view!.frame.height - 115)
                p4R.strokeColor = GameData.colors[3]
                p4R.zRotation = CGFloat(M_PI_2)
                p4R.fillColor = GameData.colors[3]
                leftArr.zRotation = CGFloat(M_PI_2)
                rightArr.setScale(0.3)
                rightArr.position = CGPoint(x: 38, y: 68)
                p4R.addChild(rightArr)
                self.addChild(p4R)
    
                p4L = SKShapeNode(path: trianglePathP1L)
                p4L.position = CGPoint(x: 10, y: view!.frame.height)
                p4L.strokeColor = GameData.colors[3]
                p4L.zRotation = CGFloat(-M_PI_2)
                p4L.fillColor = GameData.colors[3]
                
                leftArr.setScale(0.3)
                leftArr.zRotation = CGFloat(-M_PI_2)
                leftArr.position = CGPoint(x: 38, y: 68)
                p4L.addChild(leftArr)
                self.addChild(p4L)
                
                scoreLblList[3].position = CGPoint(x: 15, y: view!.frame.height - 120)
                scoreLblList[3].zRotation = CGFloat(M_PI_2) * 2
                self.addChild(scoreLblList[3])
                            
            }
            
            
            
            
        }
    
    
    
    override func update(_ currentTime: TimeInterval) {
                /* Called before each frame is rendered */
        
        for (i,player) in players.enumerated(){
            if !players[i].dead{
                moveSnake(i)
                if arc4random_uniform(600) == 5{
                    makeItems()
                }
            }
            
        }
                
    }
    
    func addPhysics(){
        players[0].head.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
        players[0].head.physicsBody!.categoryBitMask = PhysicsCat.p1HeadCat
        players[0].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.foodCat | PhysicsCat.tailCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat | PhysicsCat.p2TailCat | PhysicsCat.p3TailCat | PhysicsCat.p4TailCat | PhysicsCat.itemCat | PhysicsCat.bombCat
        players[0].head.physicsBody?.affectedByGravity = false
        players[0].head.physicsBody?.linearDamping = 0
    
        if players.count > 1 {
            players[1].head.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
            players[1].head.physicsBody!.categoryBitMask = PhysicsCat.p2HeadCat
            players[1].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.foodCat | PhysicsCat.tailCat | PhysicsCat.p1HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat | PhysicsCat.p1TailCat | PhysicsCat.p3TailCat | PhysicsCat.p4TailCat | PhysicsCat.itemCat | PhysicsCat.bombCat
            players[1].head.physicsBody?.affectedByGravity = false
            players[1].head.physicsBody?.linearDamping = 0
        }
        if players.count > 2 {
            players[2].head.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
            players[2].head.physicsBody!.categoryBitMask = PhysicsCat.p3HeadCat
            players[2].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.foodCat | PhysicsCat.tailCat | PhysicsCat.p2HeadCat | PhysicsCat.p1HeadCat | PhysicsCat.p4HeadCat | PhysicsCat.p2TailCat | PhysicsCat.p1TailCat | PhysicsCat.p4TailCat | PhysicsCat.itemCat | PhysicsCat.bombCat
            players[2].head.physicsBody?.affectedByGravity = false
            players[2].head.physicsBody?.linearDamping = 0
        }
        if players.count > 3 {
            players[3].head.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
            players[3].head.physicsBody!.categoryBitMask = PhysicsCat.p4HeadCat
            players[3].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.foodCat | PhysicsCat.tailCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p1HeadCat | PhysicsCat.p2TailCat | PhysicsCat.p3TailCat | PhysicsCat.p1TailCat | PhysicsCat.itemCat | PhysicsCat.bombCat
            players[3].head.physicsBody?.affectedByGravity = false
            players[3].head.physicsBody?.linearDamping = 0
        }
    }

 
    func didBegin(_ contact: SKPhysicsContact) {
        
    
        // PLayer + Wall Start
        // ****************************************************************
        // ****************************************************************
        
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p2TailCat)  || (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p3TailCat)  || (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4TailCat) || contact.bodyB.categoryBitMask == PhysicsCat.bombCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat{
            
            players[0].dead = true
            updateScore()
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat) ||
            (contact.bodyA.categoryBitMask == PhysicsCat.tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p1TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p3TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4TailCat) || contact.bodyB.categoryBitMask == PhysicsCat.bombCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat{
            
            players[1].dead = true
            updateScore()
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p1TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p2TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4TailCat) || contact.bodyB.categoryBitMask == PhysicsCat.bombCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat{
            
            players[2].dead = true
            updateScore()
            
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p1TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p2TailCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p3TailCat) || contact.bodyB.categoryBitMask == PhysicsCat.bombCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat{
            
            players[3].dead = true
            updateScore()
            
        }
        
        
        // ****************************************************************
        // ****************************************************************
        // Köpfe kollidieren Start
        
        if (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat){
            var oneDead = false
            if !players[0].dead && !players[1].dead{
                oneDead = true
            }
            players[0].dead = true
            players[1].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }else if (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat){
            var oneDead = false
            if !players[0].dead && !players[2].dead{
                oneDead = true
            }
            players[0].dead = true
            players[2].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }else if (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat){
            var oneDead = false
            if !players[0].dead && !players[3].dead{
                oneDead = true
            }
            players[0].dead = true
            players[3].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }else if (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat){
            var oneDead = false
            if !players[1].dead && !players[2].dead{
                oneDead = true
            }
            players[1].dead = true
            players[2].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }else if (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat){
            var oneDead = false
            if !players[1].dead && !players[3].dead{
                oneDead = true
            }
            players[1].dead = true
            players[3].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }else if (contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat){
            var oneDead = false
            if !players[2].dead && !players[3].dead{
                oneDead = true
            }
            players[2].dead = true
            players[3].dead = true
            updateScore()
            if oneDead {
                updateScore()
            }
        }
        
        
        // ****************************************************************
        // ****************************************************************
        // Köpfe kollidieren End
        // ****************************************************************
        // ****************************************************************
        // ****************************************************************
        // PLayer + Wall End
       
        
        if (contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.foodCat){
            
            addTailAndRemoveFood(contact.bodyA.node!.position, index: 0, foodName: contact.bodyA.node!.name!)
//            print(contact.bodyA.node!.frame)
        }
        if (contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.foodCat){
            
            addTailAndRemoveFood(contact.bodyA.node!.position, index: 1, foodName: contact.bodyA.node!.name!)
        }
        if (contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.foodCat){
            
            addTailAndRemoveFood(contact.bodyA.node!.position, index: 2, foodName: contact.bodyA.node!.name!)
        }
        if (contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat && contact.bodyA.categoryBitMask == PhysicsCat.foodCat){
            
            addTailAndRemoveFood(contact.bodyA.node!.position, index: 3, foodName: contact.bodyA.node!.name!)
        }
        if (contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.itemCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.itemCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.itemCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat && contact.bodyB.categoryBitMask == PhysicsCat.itemCat) {
            
            
            
            switch contact.bodyB.node!.name!{
            case "SpeedItemRed":
                increaseSpeedRed(Int(contact.bodyA.node!.name!)!)
            case "SpeedItemGreen":
                increaseSpeedGreen(Int(contact.bodyA.node!.name!)!)
            case "switchDirRed":
                changeDirection(Int(contact.bodyA.node!.name!)!)
            case "FatItemRed":
                increaseThicknessRed(Int(contact.bodyA.node!.name!)!)
            case "bombItem":
                createBombs()
            default:
                break
            }
            
            for item in itemList{
                if contact.bodyB.node!.position == item.position{
                    item.removeFromParent()
                    
                }
            }
            
           
            
        }
            
            
        
        
        
        let deadPlayers = players.filter{(obj: LineObject) -> Bool in
            obj.dead == false}
        
        
        // check if All Dead
        if deadPlayers.count <= 1 && players.count > 1{
            for (index, player) in players.enumerated(){
                player.dead = true
            }
            
            updateTableView()
            foodTimer.invalidate()
            
            
            if scoreSort[0].0 == scoreSort[1].0 && GameData.gameModeID == 0 && scoreSort[0].0 >= GameData.gameModeCount{
                GameData.gameModeCount = (scoreSort[0].0 + 5)
                gameModeLbl.text = "Neues Ziel: " + String(GameData.gameModeCount)
            }
            
            if curRound == GameData.gameModeCount && GameData.gameModeID == 1 && scoreSort[0].0 == scoreSort[1].0{

                GameData.gameModeCount += 1
                gameModeLbl.text = "Unentschieden"
                
            }
            
            
            if curRound != GameData.gameModeCount && GameData.gameModeID == 1 || scoreSort[0].0 < GameData.gameModeCount && GameData.gameModeID == 0 {
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameScene.newRound), userInfo: 0, repeats: false)
            }else{
                Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(GameScene.endScreen), userInfo: 0, repeats: false)
//                scoreView.removeFromSuperview()
//                self.removeAllActions()
//                self.removeAllChildren()
//                let scene = MainMenu(fileNamed: "MainMenu");
//                
//                scene!.scaleMode = .ResizeFill
//                
//                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVerticalWithDuration(1.5));
             //   gameEnded()
                
            }
            
            
        }
        
        if !players.contains(where: {obj -> Bool in obj.dead == false}) && players.count == 1{
            //updateTableView()
            makeEndScreen(0)
            
        }
    }
    
    func createBombs(){
        for i in 0..<5 {
            let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (2*btnWidth + 10)))) + btnWidth + 5
            let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 10)
        
            self.bomb = SKSpriteNode(imageNamed: "bomb")
            self.bomb.setScale(0.4)
            
            self.bomb.physicsBody = SKPhysicsBody(circleOfRadius: self.bomb.size.width / 1.9)
            self.bomb.physicsBody!.categoryBitMask = PhysicsCat.bombCat
            self.bomb.physicsBody!.contactTestBitMask =  PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
            self.bomb.physicsBody?.affectedByGravity = false
            self.bomb.physicsBody?.linearDamping = 0
            self.bomb.position = CGPoint(x: posX, y: posY)
            self.bombList.append(self.bomb)
            self.addChild(self.bomb)
        }
        
    }

    
    @objc func waitBeforeStart(){
        for player in players {
            player.dead = false
            
        }
        for arrow in arrows {
            arrow.isHidden = true
        }
    }
    func addHighscore(_ name: String){
        Data().saveSingleplayerHighscore(name, score: players[0].score)
    }
    
     @objc func endScreen(){
        scoreView.removeFromSuperview()
        makeEndScreen(1)
    }
    
    func closeGame(){
        
        self.view?.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func increaseSpeedGreen(_ index: Int){
        players[index].snakeVelocity += 0.5
        rightBtn(index)
        leftBtn(index)
        speedTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.decreaseSpeed), userInfo: index, repeats: false)
        
    }
    
    func changeDirection(_ index: Int){
        if index != 0{
            players[0].changeDir = true
            var intervall = 5.0
            if dir1.timeInterval > 0 {
                intervall += dir1.timeInterval
            }
            dir1 = Timer.scheduledTimer(timeInterval: intervall, target: self, selector: #selector(GameScene.changeDirectionBack), userInfo: 0, repeats: false)
        }
        if index != 1 && players.count > 1{
            players[1].changeDir = true
            var intervall = 5.0
            if dir2.timeInterval > 0 {
                intervall += dir2.timeInterval
            }
            dir2 = Timer.scheduledTimer(timeInterval: intervall, target: self, selector: #selector(GameScene.changeDirectionBack), userInfo: 1, repeats: false)
        }
        if index != 2 && players.count > 2{
            players[2].changeDir = true
            var intervall = 5.0
            if dir3.timeInterval > 0 {
                intervall += dir3.timeInterval
            }
            dir3 = Timer.scheduledTimer(timeInterval: intervall, target: self, selector: #selector(GameScene.changeDirectionBack), userInfo: 2, repeats: false)
        }
        if index != 3 && players.count > 3{
            players[3].changeDir = true
            var intervall = 5.0
            if dir4.timeInterval > 0 {
                intervall += dir4.timeInterval
            }
            dir4 = Timer.scheduledTimer(timeInterval: intervall, target: self, selector: #selector(GameScene.changeDirectionBack), userInfo: 3, repeats: false)
        }
        
    }
    
    @objc func decreaseSpeed(_ timer: Timer){
        let index = timer.userInfo as! Int
        players[index].snakeVelocity -= 0.5
        rightBtn(index)
        leftBtn(index)
    
    }
    
    @objc func changeDirectionBack(_ timer: Timer){
        let index = timer.userInfo as! Int
        switch index {
            case 0:
                players[0].changeDir = false
            case 1:
                players[1].changeDir = false
            case 2:
                players[2].changeDir = false
            case 3:
                players[3].changeDir = false
            default:
            break
        }
    }
    
    func increaseSpeedRed(_ index: Int){
        for (count,player) in players.enumerated(){
            
            if index != count{
                player.snakeVelocity += 0.5
                speedTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.decreaseSpeed), userInfo: count, repeats: false)
            }
            
        }
    }
    
    func increaseThicknessRed(_ index: Int){
        for (count,player) in players.enumerated(){
            
            if index != count{
                player.head.xScale += 0.5
                player.head.yScale = player.head.xScale
                for tail in player.tail{
                    tail.xScale = player.head.xScale
                    tail.yScale = player.head.xScale
                }
                thickTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameSceneCurve.decreaseThickness), userInfo: count, repeats: false)
            }
            
        }
    }
    
    func decreaseThickness(_ timer: Timer){
        let index = timer.userInfo as! Int
        players[index].head.xScale -= 0.5
        players[index].head.yScale = players[index].head.xScale
        for tail in players[index].tail{
            tail.xScale = players[index].head.xScale
            tail.yScale = players[index].head.xScale
        }
    }
    
    func updateTableView(){
        for (count,player) in players.enumerated(){
            scoreSort[count] = (player.score, GameData.colors[count], scoreSort[count].2)
        }
        scoreSort.sort() { $0.0 > $1.0 }
        gameModeLbl.fontColor = scoreSort[0].1
        if GameData.gameModeID == 1{
            curRound += 1
            if curRound == GameData.gameModeCount{
                gameModeLbl.text = "Letzte Runde"
            }else{
               gameModeLbl.text = "Runde " + String(curRound) + " von " + String(GameData.gameModeCount)
            }
            
            
        }
        
        scoreView.isHidden = false
        pauseBtn.alpha = 0.3
        pauseBtn2.alpha = 0.3
        gameModeView.isHidden = false
        self.scoreTableView.reloadData()
    }
    
    func updateScore(){
        let deadPlayers = players.filter{(obj: LineObject) -> Bool in
            obj.dead == false}
        if deadPlayers.count != 0{
            for (count,player) in players.enumerated(){
                if player.dead == false{
                    player.score += 5
                    scoreSort[count].2 += 5
                    scoreLblList[count].text = String(player.score)
                }
            }
        }
        
        
        
    }

    func addTailAndRemoveFood(_ contactPos: CGPoint, index: Int, foodName: String){

        for (count,foodUnit) in foodList.enumerated(){
            if contactPos == foodUnit.position{
                foodUnit.removeFromParent()
                foodList.remove(at: count)
                let newTail = SKShapeNode(circleOfRadius: 8.0)
                newTail.xScale = players[index].head.xScale
                newTail.yScale = players[index].head.yScale
                //let newTail = SKShapeNode(rectOfSize: CGSize(width: 10, height: 10))
                newTail.fillColor = GameData.colors[index]
                newTail.strokeColor = GameData.colors[index]
                //newTail.position = players[index].wayPoints[players[index].wayPoints.count - 10]
                newTail.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
                //newTail.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: 10))
                newTail.physicsBody?.affectedByGravity = false
                newTail.physicsBody?.linearDamping = 0
                newTail.physicsBody?.allowsRotation = false
                newTail.physicsBody?.isDynamic = false
                if players[index].tail.count <= 1{
                    
                    switch index {
                    case 0:
                        newTail.physicsBody?.categoryBitMask = PhysicsCat.p1TailCat
                        newTail.physicsBody?.contactTestBitMask = PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
                    case 1:
                        newTail.physicsBody?.categoryBitMask = PhysicsCat.p2TailCat
                        newTail.physicsBody?.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
                    case 2:
                        newTail.physicsBody?.categoryBitMask = PhysicsCat.p3TailCat
                        newTail.physicsBody?.contactTestBitMask = PhysicsCat.p2HeadCat | PhysicsCat.p1HeadCat | PhysicsCat.p4HeadCat
                    case 3:
                        newTail.physicsBody?.categoryBitMask = PhysicsCat.p4TailCat
                        newTail.physicsBody?.contactTestBitMask = PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p1HeadCat
                    default:
                        break
                    }

                }else{
                    newTail.physicsBody?.categoryBitMask = PhysicsCat.tailCat
                    newTail.physicsBody?.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p1HeadCat
                }
                
                self.addChild(newTail)
                players[index].tail.append(newTail)
            }
        }
        if foodList.count == 0 {
            createFood()
        }
        
        let points = SKLabelNode(fontNamed: "Chalkduster")
        points.fontSize = 15
        points.fontColor = GameData.colors[index]
        
        points.position = CGPoint(x: contactPos.x, y: contactPos.y + 10)
        
        switch foodName {
        case "Erdbeere":
            players[index].score = players[index].score + Int(round(1 * itemMultiply))
            points.text =  "+" + String(Int(round(1 * itemMultiply)))
            scoreSort[index].2 += 1
        case "Apfel":
            players[index].score = players[index].score + Int(round(2 * itemMultiply))
            points.text =  "+" + String(Int(round(2 * itemMultiply)))
            scoreSort[index].2 += 2
        case "Banane":
            players[index].score = players[index].score + Int(round(3 * itemMultiply))
            points.text =  "+" +  String(Int(round(3 * itemMultiply)))
            scoreSort[index].2 += 3
        default:
            break
        }
        scoreLblList[index].text = String(players[index].score)
        let myFunction = SKAction.run({()in self.addChild(points)})
        let wait = SKAction.wait(forDuration: 1.0)
        let remove = SKAction.run({() in points.removeFromParent()})
        self.run(SKAction.sequence([myFunction, wait, remove]))

        //NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.removeLbl), userInfo: 0, repeats: false)
    }
    
//    func removeLbl(){
//
//    }
    
    //Hide Keyboard after typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scoreName.text = textField.text!
        if scoreName.text! != "" {
            highScoreBtn.alpha = 1
        }else{
            highScoreBtn.alpha = 0.5
        }
        self.view!.endEditing(true)
        return false
    }
    //***********************************************************************************
    //***********************************************************************************
    //                                  Score Table View Start
    //***********************************************************************************
    //***********************************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        //        print(scores[indexPath.row])
//        let player = players.filter {($0.playerID == scores[indexPath.row].0)}
//        if player.count == 0{

        
        
        cell.textLabel?.textColor = scoreSort[indexPath.row].1
//        }else{
//            cell.textLabel?.textColor = hexStringToUIColor(player[0].color)
//        }
        cell.textLabel?.text = String(scoreSort[indexPath.row].0)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        cell.backgroundColor = UIColor.black
//        cell.textLabel?.text = scores[indexPath.row].1
        cell.detailTextLabel?.text = "+ " + String(scoreSort[indexPath.row].2)
        return cell
    }
    
    
//    func getColorName(index: Int){
//        
//        switch index{
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
//        
//        
//        
//    }
//    
    
    //***********************************************************************************
    //***********************************************************************************
    //                                  Score Table View End
    //***********************************************************************************
    //***********************************************************************************
    
    
//        for (index,color) in GameData.colors.enumerate(){
//            
//            
//            let line = LineObject(head: SKShapeNode(circleOfRadius: 3.0), position: CGPoint(), path: CGPathCreateMutable(), lineNode: SKShapeNode(), wayPoints: [], dead: false, lastPoint: CGPoint(), xCurve: CGFloat(1), yCurve: CGFloat(1), curveRadius: 5.0, curveSpeed: CGFloat(1))
//
//            line.head.fillColor = color
//            line.head.strokeColor = color
//            line.lineNode.fillColor = color
//            line.lineNode.strokeColor = color
//            
//            self.addChild(line.head)
//            players.append(line)
//            counter.append(0)
//            
//        }
//        newRound()
//        
//        createButtons(players.count)
//        addPhysics()
//        
//        addChild(lineContainer)
//        
//        
//        
//        
//        gameArea = SKShapeNode(rect: CGRect(x: btnWidth + 5 , y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
//        gameArea.lineWidth = 5
//        gameArea.strokeColor = SKColor.whiteColor()
//        
//        // Fügt den Wänden einen Body für die Kollisionserkennung hinzu
//        gameArea.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: btnWidth + 5, y: 5, width: view.frame.width - (2*btnWidth+10), height: view.frame.height - 10))
//        gameArea.physicsBody!.categoryBitMask = PhysicsCat.gameAreaCat
//        gameArea.physicsBody?.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
//        gameArea.physicsBody?.affectedByGravity = false
//        gameArea.physicsBody?.dynamic = false
//        self.addChild(gameArea)
//        
//        
//    }
//    
//    
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//       /* Called when a touch begins   jj*/
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            if p1R.containsPoint(location){
//                changeDirectionR2(0)
//                myTimerR1 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 0, repeats: true)
//                
//            }else if p1L.containsPoint(location){
//                changeDirectionL2(0)
//                myTimerL1 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 0, repeats: true)
//            }else if p2R.containsPoint(location){
//                changeDirectionR2(1)
//                myTimerR2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 1, repeats: true)
//                
//            }else if p2L.containsPoint(location){
//                changeDirectionL2(1)
//                myTimerL2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 1, repeats: true)
//            }else if p3R.containsPoint(location){
//                changeDirectionR2(2)
//                myTimerR3 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 2, repeats: true)
//                
//            }
//            else if p3L.containsPoint(location){
//                changeDirectionL2(2)
//                myTimerL3 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 2, repeats: true)
//            }else if p4R.containsPoint(location){
//                changeDirectionR2(3)
//                myTimerR4 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionR), userInfo: 3, repeats: true)
//                
//            }else if p4L.containsPoint(location){
//                changeDirectionL2(3)
//                myTimerL4 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.changeDirectionL), userInfo: 3, repeats: true)
//            }
//
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        for touch in touches{
//            let location = touch.locationInNode(self)
//            
//            
//            if p1R.containsPoint(location) || p1L.containsPoint(location){
//                myTimerR1.invalidate()
//                myTimerL1.invalidate()
//                
//            }else if p2R.containsPoint(location) || p2L.containsPoint(location){
//                myTimerR2.invalidate()
//                myTimerL2.invalidate()
//                
//            }else if p3R.containsPoint(location) || p3L.containsPoint(location){
//                myTimerR3.invalidate()
//                myTimerL3.invalidate()
//                
//            }else if p4R.containsPoint(location) || p4L.containsPoint(location){
//                myTimerR4.invalidate()
//                myTimerL4.invalidate()
//                
//            }
//        }
//    }
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        for touch in touches{
//            let location = touch.locationInNode(self)
//            let prevLoc = touch.previousLocationInNode(self)
//            
//            if p1R.containsPoint(prevLoc) && !p1R.containsPoint(location) || p1L.containsPoint(prevLoc) && !p1L.containsPoint(location){
//                myTimerR1.invalidate()
//                myTimerL1.invalidate()
//                
//            }else if p2R.containsPoint(prevLoc) && !p2R.containsPoint(location) || p2L.containsPoint(prevLoc) && !p2L.containsPoint(location){
//                myTimerR2.invalidate()
//                myTimerL2.invalidate()
//                
//            }else if p3R.containsPoint(prevLoc) && !p3R.containsPoint(location) || p3L.containsPoint(prevLoc) && !p3L.containsPoint(location){
//                myTimerR3.invalidate()
//                myTimerL3.invalidate()
//                
//            }else if p4R.containsPoint(prevLoc) && !p4R.containsPoint(location) || p4L.containsPoint(prevLoc) && !p4L.containsPoint(location){
//                myTimerR4.invalidate()
//                myTimerL4.invalidate()
//                
//            }
//        }
//    }
//    
//    
//       
//    //Linkskurve
//    func changeDirectionL(timer: NSTimer){
//        let playerIndex = timer.userInfo as! Int
//        changeDirectionL2(playerIndex)
//    }
//    
//    //Rechtskurve
//    func changeDirectionR(timer: NSTimer){
//        let playerIndex = timer.userInfo as! Int
//        changeDirectionR2(playerIndex)
//        
//    }
//    func changeDirectionL2(index: Int){
//        let playerIndex = index
//        let alt = pointToRadian(players[playerIndex].wayPoints[0])
//        //        if switchDirBool {
//        //           wayPoints[0] = radianToPoint(alt-curveRadius)
//        //        }else{
//        players[playerIndex].wayPoints[0] = radianToPoint(alt+players[playerIndex].curveRadius)
//        //        }
//        changeDirection(players[playerIndex].wayPoints[0], index: playerIndex)
//    }
//    
//    //Rechtskurve
//    func changeDirectionR2(index: Int){
//        let playerIndex = index
//        let alt = pointToRadian(players[playerIndex].wayPoints[0])
//        //        if switchDirBool {
//        //            wayPoints[0] = radianToPoint(alt+curveRadius)
//        //        }else{
//        players[playerIndex].wayPoints[0] = radianToPoint(alt-players[playerIndex].curveRadius)
//        //        }
//        changeDirection(players[playerIndex].wayPoints[0],index: playerIndex)
//        
//    }
//
//    
//    
//   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//        
//        for (i,player) in players.enumerate(){
//            if !player.dead{
//                drawLine(i)
//            }
//        }
//        
//        
//    }
//    
//    func drawLine(index: Int){
//        if (CGPathIsEmpty(players[index].path)) {
//            CGPathMoveToPoint(players[index].path, nil, players[index].lastPoint.x, players[index].lastPoint.y)
//            players[index].lineNode.path = nil
//            players[index].lineNode.lineWidth = 3.0
//            
//           
//            
//            self.addChild(players[index].lineNode)
//            
//            
//        }
//        
//        var x = players[index].lastPoint.x + players[index].xCurve
//        var y = players[index].lastPoint.y + players[index].yCurve
//        //CGPathAddLineToPoint(players[index].path, nil, x, y)
//        //players[index].lineNode.path = players[index].path
//        players[index].head.position = CGPoint(x: x, y: y)
//        
//        let point = SKShapeNode(circleOfRadius: 2.0)
//        point.position = CGPointMake(x, y)
//        lineContainer.addChild(point)
//        
//        counter[index] = counter[index] + 1
//        if counter[index] == 50{
//            lineContainer.removeAllChildren()
//            CGPathMoveToPoint(players[index].path, nil, players[index].wayPoints[1].x, players[index].wayPoints[1].y)
//           // players[index].lineNode.path = nil
//            players[index].lineNode.lineWidth = 3.0
//            
//            for (i,points) in players[index].wayPoints.enumerate(){
//                if i != 0{
//                    CGPathAddLineToPoint(players[index].path, nil, points.x, points.y)
//                    players[index].lineNode.path = players[index].path
//                    
//                    CGPathCloseSubpath(players[index].path)
//                }
//                
//                
//            }
//            
//            var temp  = players[index].wayPoints[0]
//            players[index].wayPoints.removeAll()
//            players[index].wayPoints.append(temp)
//            //self.addChild(players[index].lineNode)
//            
//            counter[index] = 0
//        }
////        players[index].lineNode.path = nil
//        players[index].lastPoint = CGPointMake(x, y)
//        players[index].wayPoints.append(CGPoint(x:x,y:y))
//        //addLinesToTexture(index)
//        //addPhysicsTail(index)
//        
//        
//        
//        
//    }
//    
//
//    func addLinesToTexture (index: Int) {
//        // Convert the contents of the line container to an SKTexture
//        texture = self.view!.textureFromNode(lineContainer)!
//        lineCanvas!.texture = texture
//        players[index].lineNode.removeFromParent()
//        players[index].path = CGPathCreateMutable()
//        
//    }
//    
//    // setzt Spieler i auf zufällige Startposition
//    func randomStartingPosition(i: Int){
//        let posX = CGFloat(arc4random_uniform(UInt32(view!.frame.width - (4*btnWidth+10) - 100))) + 2 * btnWidth + 10 + 50
//        let posY = CGFloat(arc4random_uniform(UInt32(view!.frame.height - 50) ) + 25)
//        let startingPosition = CGPoint(x: posX, y: posY)
//        //        print(startingPosition)
//        
//        players[i].head.position = CGPointMake(posX, posY)
//        players[i].lastPoint = CGPointMake(posX, posY)
//        players[i].wayPoints.append(startingPosition)
//        
//        let startingDirection = Double(arc4random_uniform(360))
//        players[i].curveRadius = startingDirection
//        changeDirectionL2(i)
//        players[i].curveRadius = 5.0
//    }
//
//    // fügt Physics den Köpfen der Schlangen hinzu
//    func addPhysics(){
//        players[0].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
//        players[0].head.physicsBody!.categoryBitMask = PhysicsCat.p1HeadCat
//        players[0].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p2tailCat | PhysicsCat.p3tailCat | PhysicsCat.p4tailCat
//        players[0].head.physicsBody?.affectedByGravity = false
//        players[0].head.physicsBody?.linearDamping = 0
//        
//        if players.count > 1 {
//            players[1].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
//            players[1].head.physicsBody!.categoryBitMask = PhysicsCat.p2HeadCat
//            players[1].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p3tailCat | PhysicsCat.p4tailCat
//            players[1].head.physicsBody?.affectedByGravity = false
//            players[1].head.physicsBody?.linearDamping = 0
//        }
//        if players.count > 2 {
//            players[2].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
//            players[2].head.physicsBody!.categoryBitMask = PhysicsCat.p3HeadCat
//            players[2].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p2tailCat | PhysicsCat.p4tailCat
//            players[2].head.physicsBody?.affectedByGravity = false
//            players[2].head.physicsBody?.linearDamping = 0
//        }
//        if players.count > 3 {
//            players[3].head.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
//            players[3].head.physicsBody!.categoryBitMask = PhysicsCat.p4HeadCat
//            players[3].head.physicsBody!.contactTestBitMask = PhysicsCat.gameAreaCat | PhysicsCat.p1tailCat | PhysicsCat.p2tailCat | PhysicsCat.p3tailCat
//            players[3].head.physicsBody?.affectedByGravity = false
//            players[3].head.physicsBody?.linearDamping = 0
//        }
//    }
//    
//    // fügt Physics den Tails der Schlangen hinzu, funktioniert leider noch nicht
//    func addPhysicsTail(i: Int){
//        
//        let pBody = SKPhysicsBody(edgeChainFromPath: players[i].path)
//        switch i {
//        case 0:
//            pBody.categoryBitMask = PhysicsCat.p1tailCat
//            pBody.contactTestBitMask = PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
//        case 1:
//            pBody.categoryBitMask = PhysicsCat.p2tailCat
//            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p3HeadCat | PhysicsCat.p4HeadCat
//        case 2:
//            pBody.categoryBitMask = PhysicsCat.p3tailCat
//            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p4HeadCat
//        case 3:
//            pBody.categoryBitMask = PhysicsCat.p4tailCat
//            pBody.contactTestBitMask = PhysicsCat.p1HeadCat | PhysicsCat.p2HeadCat | PhysicsCat.p3HeadCat
//        default:
//            print("default")
//        }
//        pBody.affectedByGravity = false
//        pBody.linearDamping = 0
////        players[i].lineNode.physicsBody = pBody
////        if players[i].lineNode.physicsBody != nil {
////            let bodies = SKPhysicsBody(bodies: [players[i].lineNode.physicsBody!, pBody])
////            players[i].lineNode.physicsBody = bodies
////        }else{
////            players[i].lineNode.physicsBody = pBody
////        }
//    }
//    
//    
//    func createButtons(playerCount: Int){
//        
//        
//        CGPathMoveToPoint(trianglePathP1L, nil, 5, 100)
//        CGPathAddLineToPoint(trianglePathP1L, nil, 105, 100)
//        CGPathAddLineToPoint(trianglePathP1L, nil, 5, 0)
//        CGPathCloseSubpath(trianglePathP1L)
//        
//        
//        // Für 1 und 2 Spieler
//        if playerCount <= 2{
//            p1L = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
//            p1L.position = CGPoint(x: 50, y: 60 )
//            p1L.strokeColor = GameData.colors[0]
//            p1L.fillColor = GameData.colors[0]
//            self.addChild(p1L)
//            p1R = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
//            p1R.position = CGPoint(x: view!.frame.width-50, y: 60)
//            p1R.strokeColor = GameData.colors[0]
//            p1R.fillColor = GameData.colors[0]
//            self.addChild(p1R)
//        }
//    
//        
//        // Für genau 2. Spieler
//        if playerCount == 2{            
//            p2L = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
//            p2L.position = CGPoint(x: view!.frame.width-50, y: view!.frame.height-50 )
//            p2L.strokeColor = GameData.colors[1]
//            p2L.fillColor = GameData.colors[1]
//            self.addChild(p2L)
//            p2R = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
//            p2R.position = CGPoint(x: 50, y: view!.frame.height-50)
//            p2R.strokeColor = GameData.colors[1]
//            p2R.fillColor = GameData.colors[1]
//            self.addChild(p2R)
//        }
//        
//        
//        // Buttons für 1.-3. Spieler
//        if playerCount > 2 {
//            
//            p1L = SKShapeNode(path: trianglePathP1L)
//            p1L.position = CGPoint(x: 0, y: 10)
//            p1L.strokeColor = GameData.colors[0]
//            p1L.fillColor = GameData.colors[0]
//            self.addChild(p1L)
//            
//            p1R = SKShapeNode(path: trianglePathP1L)
//            p1R.position = CGPoint(x: 5 + 110, y: 105)
//            p1R.strokeColor = GameData.colors[0]
//            p1R.fillColor = GameData.colors[0]
//            p1R.zRotation = CGFloat(-M_PI_4)*4
//            self.addChild(p1R)
//            
//            
//            p3L = SKShapeNode(path: trianglePathP1L)
//            p3L.position = CGPoint(x: view!.frame.width - 10 , y: 0)
//            p3L.strokeColor = GameData.colors[2]
//            p3L.zRotation = CGFloat (M_PI_2)
//            p3L.fillColor = GameData.colors[2]
//            self.addChild(p3L)
//            
//            p3R = SKShapeNode(path: trianglePathP1L)
//            p3R.position = CGPoint(x: view!.frame.width - 105 , y: 115)
//            p3R.strokeColor = GameData.colors[2]
//            p3R.zRotation = CGFloat (-M_PI_2)
//            p3R.fillColor = GameData.colors[2]
//            p3R.alpha = 0.3
//            self.addChild(p3R)
//            
//            
//            p2R = SKShapeNode(path: trianglePathP1L)
//            p2R.position = CGPoint(x:view!.frame.width - 115, y: view!.frame.height - 105)
//            p2R.strokeColor = GameData.colors[1]
//            p2R.fillColor = GameData.colors[1]
//            self.addChild(p2R)
//            
//            p2L = SKShapeNode(path: trianglePathP1L)
//            p2L.position = CGPoint(x: view!.frame.width, y: view!.frame.height - 10)
//            p2L.strokeColor = GameData.colors[1]
//            p2L.zRotation = CGFloat(M_PI)
//            p2L.fillColor = GameData.colors[1]
//            self.addChild(p2L)
//            
//
//            
//        }
//        // Buttons für 4. Spieler
//        if playerCount > 3 {
//            
//
//            p4R = SKShapeNode(path: trianglePathP1L)
//            p4R.position = CGPoint(x: 105, y: view!.frame.height - 115)
//            p4R.strokeColor = GameData.colors[3]
//            p4R.zRotation = CGFloat(M_PI_2)
//            p4R.fillColor = GameData.colors[3]
//            self.addChild(p4R)
//            
//            p4L = SKShapeNode(path: trianglePathP1L)
//            p4L.position = CGPoint(x: 10, y: view!.frame.height)
//            p4L.strokeColor = GameData.colors[3]
//            p4L.zRotation = CGFloat(-M_PI_2)
//            p4L.fillColor = GameData.colors[3]
//            self.addChild(p4L)
//                        
//        }
//        
//        
//        
//        
//    }
//    
//    
//    // Für Kurve -> Punkt zu Radius
//    func pointToRadian(targetPoint: CGPoint) -> Double{
//        let deltaX = targetPoint.x;
//        let deltaY = targetPoint.y;
//        let rad = atan2(deltaY, deltaX); // In radians
//        return ( Double(rad) * (180 / M_PI))
//    }
//    
//    //Für Kurve -> Radius zu Punkt
//    func radianToPoint(rad: Double) -> CGPoint{
//        return CGPoint(x: cos(rad*(M_PI/180))*141, y: sin(rad*(M_PI/180))*141)
//    }
//    
//    
//    
//    //Für Kurve + Geschwindigkeit
//    func changeDirection(targetPoint: CGPoint, index: Int){
//        let currentPosition = position
//        let offset = CGPoint(x: targetPoint.x - currentPosition.x, y: targetPoint.y - currentPosition.y)
//        let length = Double(sqrtf(Float(offset.x * offset.x) + Float(offset.y * offset.y)))
//        let direction = CGPoint(x:CGFloat(offset.x) / CGFloat(length), y: CGFloat(offset.y) / CGFloat(length))
//        players[index].xCurve = direction.x * players[index].curveSpeed
//        players[index].yCurve = direction.y * players[index].curveSpeed
//        
//        
//    }
//    
//    
//    func newRound(){
//        lineContainer.removeAllChildren()
//        lineCanvas = SKSpriteNode(color:SKColor.clearColor(),size:view!.frame.size)
//        lineCanvas!.anchorPoint = CGPointZero
//        lineCanvas!.position = CGPointZero
//        lineContainer.addChild(lineCanvas!)
//        texture = SKTexture()
//        for (index,player) in players.enumerate(){
////            addLinesToTexture(index)
//            randomStartingPosition(index)
//        }
//        
//    }
//
//    
//    // Kollisionen mit Wand und Tail der Gegner
//    func didBeginContact(contact: SKPhysicsContact) {
//        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p1HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p1HeadCat) {
//            players[0].dead = true
//            
//        }
//        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p2HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p2HeadCat)  {
//            players[1].dead = true
//            
//        }
//        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p3HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p4tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p3HeadCat)  {
//            players[2].dead = true
//            
//        }
//        if (contact.bodyA.categoryBitMask == PhysicsCat.gameAreaCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p1tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyA.categoryBitMask == PhysicsCat.p2tailCat && contact.bodyB.categoryBitMask == PhysicsCat.p4HeadCat) || (contact.bodyB.categoryBitMask == PhysicsCat.p3tailCat && contact.bodyA.categoryBitMask == PhysicsCat.p4HeadCat)  {
//            players[3].dead = true
//            
//        }
//    }
//    
//    
}

