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
    
    var gamemodeID = 0
    var curveID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamemodeTxtField.delegate = self
        //gamemodeTxtField.keyboardType = UIKeyboardType.NumberPad
        let cornerRadius = CGFloat(20)
        saveBtn.layer.cornerRadius = cornerRadius
        cancelBtn.layer.cornerRadius = cornerRadius
        
        
    }
    @IBAction func gameModeAction(sender: AnyObject) {
        
        switch gamemodeSegment.selectedSegmentIndex {
        case 0:
            gamemodeID = 0
            gamemodeLbl.text = "Zu erreichende Punkte: "
        case 1:
            gamemodeID = 1
            gamemodeLbl.text = "Anzahl der Runden: "
        default:
            break
        }
        
        
        
    }
    @IBAction func curveModeAction(sender: AnyObject) {
        
        switch curveSegment.selectedSegmentIndex {
        case 0:
            curveID = 0
        case 1:
            curveID = 1
        default:
            break
        }
        
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
