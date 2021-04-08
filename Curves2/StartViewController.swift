//
//  StartViewController.swift
//  Curves2
//
//  Created by Sebastian Haußmann on 27.06.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit


class StartViewController: UIViewController {
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p3Button: UIButton!
    @IBOutlet weak var p4Button: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var editedSettings: Bool = false
    var playerCount = 2
    var nickname = ""
    
    
    override func viewDidLoad() {
        let cornerRadius = CGFloat(20)
        addButton.layer.cornerRadius = cornerRadius
        removeButton.layer.cornerRadius = cornerRadius
        startButton.layer.cornerRadius = cornerRadius
//        settingsButton.layer.cornerRadius = cornerRadius
        
        super.viewDidLoad()
        playerCount = 2
        for i in 0..<4 {
            changeColor(i)
            p1Button.layer.cornerRadius = cornerRadius
            p2Button.layer.cornerRadius = cornerRadius
            p3Button.layer.cornerRadius = cornerRadius
            p4Button.layer.cornerRadius = cornerRadius
        }
        checkButtons()
        
    }
    
    @IBAction func addPlayer(_ sender: AnyObject) {
        playerCount = playerCount + 1
        checkButtons()
    }
    @IBAction func removePlayer(_ sender: AnyObject) {
        playerCount = playerCount - 1
        checkButtons()
    }
    
    func checkButtons(){
        switch playerCount {
        case 1:
            p1Button.isHidden = false
            p2Button.isHidden = true
            p3Button.isHidden = true
            p4Button.isHidden = true
            addButton.isHidden = false
            removeButton.isHidden = true
        case 2:
            if p2Button.backgroundColor == p1Button.backgroundColor{
                changeColor(1)
            }
            p1Button.isHidden = false
            p2Button.isHidden = false
            p3Button.isHidden = true
            p4Button.isHidden = true
            addButton.isHidden = false
            removeButton.isHidden = false
        case 3:
            if p3Button.backgroundColor == p2Button.backgroundColor || p3Button.backgroundColor == p1Button.backgroundColor{
                changeColor(2)
            }
            p1Button.isHidden = false
            p2Button.isHidden = false
            p3Button.isHidden = false
            p4Button.isHidden = true
            addButton.isHidden = false
            removeButton.isHidden = false
        case 4:
            if p4Button.backgroundColor == p3Button.backgroundColor || p4Button.backgroundColor == p2Button.backgroundColor || p4Button.backgroundColor == p1Button.backgroundColor{
                changeColor(3)
            }
            p1Button.isHidden = false
            p2Button.isHidden = false
            p3Button.isHidden = false
            p4Button.isHidden = false
            addButton.isHidden = true
            removeButton.isHidden = false
        default:
            p1Button.isHidden = false
            p2Button.isHidden = false
            p3Button.isHidden = true
            p4Button.isHidden = true
            addButton.isHidden = false
            removeButton.isHidden = false
        }
    }
    
    
    @IBAction func startButton(_ sender: AnyObject) {
    }
    @IBAction func p1Color(_ sender: AnyObject) {
        changeColor(0)
    }
    @IBAction func p2Color(_ sender: AnyObject) {
        changeColor(1)
    }
    @IBAction func p3Action(_ sender: AnyObject) {
        changeColor(2)
    }
    @IBAction func p4Action(_ sender: AnyObject) {
        changeColor(3)
    }
    
    func changeColor(_ number: Int){
        var randomColors = [UIColor.magenta, UIColor.blue,UIColor.brown, UIColor.cyan, UIColor.green, UIColor.gray, UIColor.orange, UIColor.red, UIColor.purple, UIColor.yellow, UIColor.white]
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p1Button.backgroundColor
        }
        if playerCount > 1{
            randomColors = randomColors.filter { (color: UIColor) -> Bool in
                color != p2Button.backgroundColor
            }
        }
        if playerCount > 2{
            randomColors = randomColors.filter { (color: UIColor) -> Bool in
                color != p3Button.backgroundColor
            }
        }
        if playerCount > 3{
            randomColors = randomColors.filter { (color: UIColor) -> Bool in
                color != p4Button.backgroundColor
            }
        }
        let colorInt = arc4random_uniform(UInt32(randomColors.count))
        switch number {
        case 0:
            p1Button.backgroundColor = randomColors[Int(colorInt)]
        case 1:
            p2Button.backgroundColor = randomColors[Int(colorInt)]
        case 2:
            p3Button.backgroundColor = randomColors[Int(colorInt)]
        case 3:
            p4Button.backgroundColor = randomColors[Int(colorInt)]
        default:
            print("Fail Color")
        }
    }
//    func enterName(){
//        let alertController = UIAlertController(title: "Name", message: "Bitte den Namen für die Highscore eingeben:", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alertController.addTextFieldWithConfigurationHandler(nil)
//        self.presentViewController(alertController,animated: true, completion: nil)
//        
//        
//        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
//            self.nickname = alertController.textFields![0].text!
//            self.performSegueWithIdentifier("startGame", sender:self)
//            
//        }))
//       
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startGame" {
            var colors = [UIColor]()
            colors.append(p1Button.backgroundColor!)
            if playerCount == 1 {
                GameData.singlePlayer = true
//                if nickname == ""{
//                    enterName()
//                }
//                GameData.nickname = nickname
            }
            if playerCount > 1 {
                colors.append(p2Button.backgroundColor!)
                GameData.singlePlayer = false
            }
            if playerCount > 2 {
                colors.append(p3Button.backgroundColor!)
            }
            if playerCount > 3 {
                colors.append(p4Button.backgroundColor!)
            }
            GameData.colors = colors
            if !GameData.settingsEdited{
                GameData.gameModeID = 0
                GameData.gameModeCount = 50
                GameData.curveMode = 0
                GameData.singlePlayerVelocity = 2.0
            }
        }
    }
    
}
