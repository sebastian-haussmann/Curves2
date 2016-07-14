//
//  SettingsViewController.swift
//  Curves2
//
//  Created by Moritz Martin on 06.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var gamemodeSegment: UISegmentedControl!
    @IBOutlet weak var curveSegment: UISegmentedControl!
    @IBOutlet weak var gamemodeLbl: UILabel!
    @IBOutlet weak var gamemodeTxtField: UITextField!
    
    @IBOutlet weak var curveSegment2: UISegmentedControl!
    @IBOutlet weak var velocitySlider: UISlider!
    var gamemodeID = 0
    var curveID = 0
    var pointsOrRounds = 50
    var prevTextField = "50"

    @IBOutlet weak var velocityTxtField: UILabel!
    @IBOutlet weak var multiplayerView: UIView!
    @IBOutlet weak var singlePlayerView: UIView!
    @IBOutlet weak var switchView: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if GameData.settingsEdited{
            gamemodeID = GameData.gameModeID
            gamemodeSegment.selectedSegmentIndex = gamemodeID
            curveID = GameData.curveMode
            curveSegment.selectedSegmentIndex = curveID
            curveSegment2.selectedSegmentIndex = curveID
            pointsOrRounds = GameData.gameModeCount
            gamemodeTxtField.text = String(pointsOrRounds)
            velocitySlider.value = Float(GameData.singlePlayerVelocity)
        }
        velocityTxtField.text = String(Int(velocitySlider.value))
        
        
        gamemodeTxtField.delegate = self
        gamemodeTxtField.keyboardType = UIKeyboardType.NumberPad
        let cornerRadius = CGFloat(20)
        saveBtn.layer.cornerRadius = cornerRadius
        cancelBtn.layer.cornerRadius = cornerRadius
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    @IBAction func sliderMoved(sender: AnyObject) {
        
        velocityTxtField.text = String(Int(velocitySlider.value))
        GameData.singlePlayerVelocity = CGFloat(Int(velocitySlider.value))
        
    }
    
    
    
    @IBAction func switchViewAction(sender: AnyObject) {
        
        switch switchView.selectedSegmentIndex{
        case 0:
            singlePlayerView.hidden = true
            multiplayerView.hidden = false
        case 1:
            singlePlayerView.hidden = false
            multiplayerView.hidden = true
        default:
            break
        }
        
    }
    
    
    @IBAction func gameModeAction(sender: AnyObject) {
        
        switch gamemodeSegment.selectedSegmentIndex {
        case 0:
            gamemodeID = 0
            gamemodeLbl.text = "Zu erreichende Punkte: "
            gamemodeTxtField.text = String(50)
            pointsOrRounds = Int(gamemodeTxtField.text!)!
        case 1:
            gamemodeID = 1
            gamemodeLbl.text = "Anzahl der Runden: "
            gamemodeTxtField.text = String(5)
            pointsOrRounds = Int(gamemodeTxtField.text!)!
        default:
            break
        }
        
        
        
    }
    @IBAction func curveModeAction(sender: AnyObject) {
        
        switch curveSegment.selectedSegmentIndex {
        case 0:
            curveID = 0
            curveSegment2.selectedSegmentIndex = 0
        case 1:
            curveID = 1
            curveSegment2.selectedSegmentIndex = 1
        default:
            break
        }
        
    }
    
    @IBAction func curveModeAction2(sender: AnyObject) {
        switch curveSegment2.selectedSegmentIndex {
        case 0:
            curveID = 0
            curveSegment.selectedSegmentIndex = 0
        case 1:
            curveID = 1
            curveSegment.selectedSegmentIndex = 1
        default:
            break
        }
        
        
        
    }
    @IBAction func saveBtnPressed(sender: AnyObject) {
        
       // print(pointsOrRounds)
        
    }
    
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveSettings" {
            let vc = segue.destinationViewController as! StartViewController
            GameData.gameModeID = gamemodeID
            GameData.gameModeCount = pointsOrRounds
            GameData.curveMode = curveID
            GameData.settingsEdited = true
            GameData.singlePlayerVelocity = CGFloat(Int(velocitySlider.value))
            vc.editedSettings = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    func didTapView(){
        
        if gamemodeTxtField.text == "" {
            gamemodeTxtField.text = prevTextField
        }else{
            prevTextField = gamemodeTxtField.text!
        }
        pointsOrRounds = Int(gamemodeTxtField.text!)!
        self.view.endEditing(true)
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
