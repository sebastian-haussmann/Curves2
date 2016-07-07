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
    override func viewDidLoad() {
        let cornerRadius = CGFloat(20)
        addButton.layer.cornerRadius = cornerRadius
        removeButton.layer.cornerRadius = cornerRadius
        startButton.layer.cornerRadius = cornerRadius
        settingsButton.layer.cornerRadius = cornerRadius
        
        super.viewDidLoad()
        playerCount = 2
        for var i=0; i < 4; i=i+1 {
            changeColor(i)
            p1Button.layer.cornerRadius = cornerRadius
            p2Button.layer.cornerRadius = cornerRadius
            p3Button.layer.cornerRadius = cornerRadius
            p4Button.layer.cornerRadius = cornerRadius
        }
        checkButtons()
        
    }
    
    @IBAction func addPlayer(sender: AnyObject) {
        playerCount = playerCount + 1
        checkButtons()
    }
    @IBAction func removePlayer(sender: AnyObject) {
        playerCount = playerCount - 1
        checkButtons()
    }
    
    func checkButtons(){
        switch playerCount {
        case 1:
            p1Button.hidden = false
            p2Button.hidden = true
            p3Button.hidden = true
            p4Button.hidden = true
            addButton.hidden = false
            removeButton.hidden = true
        case 2:
            p1Button.hidden = false
            p2Button.hidden = false
            p3Button.hidden = true
            p4Button.hidden = true
            addButton.hidden = false
            removeButton.hidden = false
        case 3:
            p1Button.hidden = false
            p2Button.hidden = false
            p3Button.hidden = false
            p4Button.hidden = true
            addButton.hidden = false
            removeButton.hidden = false
        case 4:
            p1Button.hidden = false
            p2Button.hidden = false
            p3Button.hidden = false
            p4Button.hidden = false
            addButton.hidden = true
            removeButton.hidden = false
        default:
            p1Button.hidden = false
            p2Button.hidden = false
            p3Button.hidden = true
            p4Button.hidden = true
            addButton.hidden = false
            removeButton.hidden = false
        }
    }
    
    
    @IBAction func startButton(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func p1Color(sender: AnyObject) {
        changeColor(0)
    }
    @IBAction func p2Color(sender: AnyObject) {
        changeColor(1)
    }
    @IBAction func p3Action(sender: AnyObject) {
        changeColor(2)
    }
    @IBAction func p4Action(sender: AnyObject) {
        changeColor(3)
    }
    
    func changeColor(number: Int){
        var randomColors = [UIColor.blueColor(),UIColor.brownColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.grayColor(), UIColor.orangeColor(), UIColor.redColor(), UIColor.purpleColor(), UIColor.yellowColor(), UIColor.whiteColor()]
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p1Button.backgroundColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p2Button.backgroundColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p3Button.backgroundColor
        }
        randomColors = randomColors.filter { (color: UIColor) -> Bool in
            color != p4Button.backgroundColor
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startGame" {
            var colors = [UIColor]()
            colors.append(p1Button.backgroundColor!)
            if playerCount > 1 {
                colors.append(p2Button.backgroundColor!)
            }
            if playerCount > 2 {
                colors.append(p3Button.backgroundColor!)
            }
            if playerCount > 3 {
                colors.append(p4Button.backgroundColor!)
            }
            GameData.colors = colors
            if !editedSettings{
                GameData.gameModeID = 0
                GameData.gameModeCount = 50
                GameData.curveMode = 0
            }
        }
    }
    
}