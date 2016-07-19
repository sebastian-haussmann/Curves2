//
//  Highscore.swift
//  Curves2
//
//  Created by Sebastian Haußmann on 11.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit
import CoreData

class Highscore: UIViewController, UITableViewDataSource  {
    
    let mpRanking = [["hjabs",300], ["askjn",200]]
    
    var spRanking = [NSManagedObject]()
    var singleplayer = true
    
    
    @IBOutlet weak var modus: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove empty table part
        let tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.allowsSelection = false
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        spRanking = Data().loadSingleplayerHighscore(singleplayer)
        for (index,rank) in spRanking.enumerate(){
            if index > 19 {
                Data().removeItemSingleplayerHighscore(rank)
            }
        }
        spRanking = Data().loadSingleplayerHighscore(singleplayer)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if modus.selectedSegmentIndex == 0{
            if spRanking.count <= 20{
                returnValue = spRanking.count
            }else{
                returnValue = 20
            }
        }else{
            returnValue = mpRanking.count
        }
        return returnValue
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HighscoreCell
        
        cell.rank.text = String(indexPath.row+1)
        if modus.selectedSegmentIndex == 0{
            let rank = spRanking[indexPath.row]
            cell.name.text = rank.valueForKey("name") as? String
            cell.score.text = String((rank.valueForKey("score") as? Int)!)
        }else{
            cell.name.text = mpRanking[indexPath.row][0] as? String
            cell.score.text = String(mpRanking[indexPath.row][1] as! Int)
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.rank.textColor = UIColor.whiteColor()
        cell.name.textColor = UIColor.whiteColor()
        cell.score.textColor = UIColor.whiteColor()
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            Data().removeItemSingleplayerHighscore(spRanking[indexPath.row])
            spRanking = Data().loadSingleplayerHighscore(singleplayer)
            tableView.reloadData()
            // remove the deleted item from the `UITableView`
            //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    @IBAction func modusAction(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Warnung", message: "Sind Sie sicher dass sie die Highscore zurücksetzen möchten? Dies kann nicht rückgängig gemacht werden.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.Cancel, handler: nil))
        let saveAction = UIAlertAction(title: "Zurücksetzen", style: UIAlertActionStyle.Destructive, handler: { (action:UIAlertAction) -> Void in
            
            Data().resetSingleplayerHighscore()
            self.spRanking = Data().loadSingleplayerHighscore(self.singleplayer)
            self.tableView.reloadData()
        })
        alert.addAction(saveAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
