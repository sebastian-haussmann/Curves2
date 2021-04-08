//
//  HighscoreScene.swift
//  Curves2
//
//  Created by Moritz Martin on 15.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import SpriteKit
import CoreData

class HighscoreScene: SKScene, UITableViewDataSource, UITableViewDelegate{
    
    var rankView: UIView = UIView()
    var rankTableView: UITableView = UITableView()
    var countTableView: UITableView = UITableView()
    
    
    var spRanking = [NSManagedObject]()
    var singleplayer = true
    
    let backButton = SKShapeNode(rectOf: CGSize(width: 140, height: 60), cornerRadius: 20)
    let resetButton = SKShapeNode(rectOf: CGSize(width: 140, height: 60), cornerRadius: 20)
    
    let backLbl = SKLabelNode(fontNamed: "TimesNewRoman")
    let resetLbl = SKLabelNode(fontNamed: "TimesNewRoman")
    let highscoreLbl = SKLabelNode(fontNamed: "TimesNewRoman")
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        
        
        
        spRanking = Data().loadSingleplayerHighscore(singleplayer)
        
        rankView = UIView(frame: CGRect(x: 0, y: 0,width: view.frame.width, height: view.frame.height))
        rankTableView = UITableView(frame: CGRect(origin: CGPoint(x: 20,y: 80), size: CGSize(width: view.frame.width - 50, height: view.frame.height - 80)))
        //countTableView = UITableView(frame: CGRect(origin: CGPoint(x: 10,y: 80), size: CGSize(width: 60, height: view.frame.height - 80)))
        
        rankView.backgroundColor = UIColor.black
        rankView.addSubview(rankTableView)
        rankView.addSubview(countTableView)
        rankTableView.dataSource = self
        rankTableView.delegate = self
//        countTableView.dataSource = self
//        countTableView.delegate = self
        rankTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let tblView =  UIView(frame: CGRect.zero)
        rankTableView.tableFooterView = tblView
        rankTableView.tableFooterView!.isHidden = true
        rankTableView.backgroundColor = UIColor.black
        
//        countTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell2")
//        let tblView2 =  UIView(frame: CGRectZero)
//        countTableView.tableFooterView = tblView2
//        countTableView.tableFooterView!.hidden = true
//        countTableView.backgroundColor = UIColor.redColor()
//        

        self.view?.addSubview(rankView)
        
        highscoreLbl.text = "Highscore"
        highscoreLbl.position = CGPoint(x: view.frame.width / 2, y: view.frame.height - 50)
        self.addChild(highscoreLbl)
        
        backButton.fillColor = UIColor.blue
        backButton.strokeColor = UIColor.blue
        backButton.position = CGPoint(x: view.frame.width - 80, y: view.frame.height - 40)
        self.addChild(backButton)
        backLbl.text = "Menü"
        backLbl.fontSize = 25
        backButton.addChild(backLbl)
        
        resetButton.fillColor = UIColor.blue
        resetButton.strokeColor = UIColor.blue
        resetButton.position = CGPoint(x: 80, y: view.frame.height - 40)
        self.addChild(resetButton)
        resetLbl.text = "Reset"
        resetLbl.fontSize = 25
        resetButton.addChild(resetLbl)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spRanking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if tableView == rankTableView{
        
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        
            let rank = spRanking[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = String(indexPath.row+1) + "                                                              " + String(rank.value(forKey: "name") as! String)
            cell.detailTextLabel?.text = String((rank.value(forKey: "score") as? Int)!)
            cell.detailTextLabel?.textColor = UIColor.white
        
            return cell
//        }else{
//           let cell2: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell2")
//            let rank = spRanking[indexPath.row]
//            cell2.textLabel?.textColor = UIColor.whiteColor()
//            cell2.backgroundColor = UIColor.clearColor()
//            cell2.textLabel?.text = String(indexPath.row)
//            return cell2
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Called when a touch begins   jj*/
        
        for touch in touches {
            let location = touch.location(in: self)
            if backButton.contains(location){
                self.view?.window?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            
        }
    }
    
    
}
