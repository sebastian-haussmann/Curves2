//
//  Data.swift
//  Curves2
//
//  Created by Sebastian Haußmann on 14.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit
import CoreData

class Data{
    
    func saveSingleplayerHighscore(_ player: String, score: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "SingleplayerHighscore", in:managedContext)
        let newRanking = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        newRanking.setValue(player, forKey: "name")
        newRanking.setValue(score, forKey: "score")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func loadSingleplayerHighscore(_ singleplayer: Bool) -> [NSManagedObject]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SingleplayerHighscore")
        
        // sort less rounds as best
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            return results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return [NSManagedObject]()
    }
    
    func resetSingleplayerHighscore(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let coord = appDelegate.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SingleplayerHighscore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func removeItemSingleplayerHighscore(_ score: NSManagedObject){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.delete(score)
        
        do {
            try context.save()
        } catch _ {
        }
    }
}
