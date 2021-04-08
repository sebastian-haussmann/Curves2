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
        let tblView =  UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView!.isHidden = true
        tableView.backgroundColor = UIColor.clear
        
        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = false
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spRanking = Data().loadSingleplayerHighscore(singleplayer)
        for (index,rank) in spRanking.enumerated(){
            if index > 19 {
                Data().removeItemSingleplayerHighscore(rank)
            }
        }
        spRanking = Data().loadSingleplayerHighscore(singleplayer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HighscoreCell
        
        cell.rank.text = String(indexPath.row+1)
        if modus.selectedSegmentIndex == 0{
            let rank = spRanking[indexPath.row]
            cell.name.text = rank.value(forKey: "name") as? String
            cell.score.text = String((rank.value(forKey: "score") as? Int)!)
        }else{
            cell.name.text = mpRanking[indexPath.row][0] as? String
            cell.score.text = String(mpRanking[indexPath.row][1] as! Int)
        }
        cell.backgroundColor = UIColor.clear
        cell.rank.textColor = UIColor.white
        cell.name.textColor = UIColor.white
        cell.score.textColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
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
    
    @IBAction func modusAction(_ sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Warnung", message: "Sind Sie sicher dass sie die Highscore zurücksetzen möchten? Dies kann nicht rückgängig gemacht werden.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.cancel, handler: nil))
        let saveAction = UIAlertAction(title: "Zurücksetzen", style: UIAlertAction.Style.destructive, handler: { (action:UIAlertAction) -> Void in
            
            Data().resetSingleplayerHighscore()
            self.spRanking = Data().loadSingleplayerHighscore(self.singleplayer)
            self.tableView.reloadData()
        })
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
