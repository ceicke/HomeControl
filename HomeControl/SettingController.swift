//
//  SettingController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 16.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class SettingController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var settings = [NSManagedObject]()
    
    @IBAction func addSetting(sender: AnyObject) {
        let alert = UIAlertController(
            title: "Neuer Aktor",
            message: nil,
            preferredStyle: .Alert
        )
        
        let saveAction = UIAlertAction(title: "Speichern",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveSetting(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
        }
        
        let textField = alert.textFields!.first
        textField!.autocapitalizationType = UITextAutocapitalizationType.Words
        textField!.autocorrectionType = UITextAutocorrectionType.Default
        textField!.placeholder = "Name des Aktors"
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Aktoren"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showActorDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print(settings[indexPath.row])
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                (segue.destinationViewController as! ActorDetailController).actor = settings[indexPath.row] as? Actor
                (segue.destinationViewController as! ActorDetailController).managedObjectContext = appDelegate.managedObjectContext
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        
        do {
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            settings = results as! [NSManagedObject]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return settings.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            self.configureCell(cell, atIndexPath: indexPath)
            
            return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let setting = settings[indexPath.row]
        cell.textLabel!.text = setting.valueForKey("name")!.description
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func saveSetting(name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Actor", inManagedObjectContext:managedContext!)
        
        let setting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        setting.setValue(name, forKey: "name")
        
        do {
            try managedContext!.save()
            settings.append(setting)
        } catch let error as NSError  {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
}
