//
//  Highscore.swift
//  Curves2
//
//  Created by Sebastian Haußmann on 11.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit

class Highscore: UIViewController, UITableViewDataSource  {
    
    let spRanking = [["hans",1000],["peter",500],["fritz",200]]
    let mpRanking = [["hjabs",300], ["askjn",200]]
    
    
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if modus.selectedSegmentIndex == 0{
            returnValue = spRanking.count
        }else{
            returnValue = mpRanking.count
        }
        return returnValue
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HighscoreCell
        
        cell.rank.text = String(indexPath.row+1)
        if modus.selectedSegmentIndex == 0{
            cell.name.text = spRanking[indexPath.row][0] as? String
            cell.score.text = String(spRanking[indexPath.row][1] as! Int)
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
    
    @IBAction func modusAction(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetButton(sender: AnyObject) {
    }
}
