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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext = NSManagedObjectContext()
    
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
    
    @IBOutlet weak var editActorButton: UIBarButtonItem!
    
    @IBAction func editActorList(sender: UIBarButtonItem) {
        
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
            editActorButton.title = "Bearbeiten"
            saveOrdering()
        } else {
            self.tableView.setEditing(true, animated: false)
            editActorButton.title = "Fertig"
        }
    }
    
    override func viewDidLoad() {
        managedContext = appDelegate.managedObjectContext!
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showActorDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                (segue.destinationViewController as! ActorDetailController).actor = settings[indexPath.row] as? Actor
                (segue.destinationViewController as! ActorDetailController).managedObjectContext = appDelegate.managedObjectContext
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
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
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                
                managedContext.deleteObject(self.settings[indexPath.row])
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    NSLog("Could not save the actor. Error: \(error)")
                }
                
                self.settings.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.reloadData()
                
            default:
                return
            }
    }
    
    // called when a row is moved
    override func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            // remove the dragged row's model
            let val = self.settings.removeAtIndex(sourceIndexPath.row)
            
            // insert it into the new position
            self.settings.insert(val, atIndex: destinationIndexPath.row)
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
        let entity =  NSEntityDescription.entityForName("Actor", inManagedObjectContext:managedContext)
        let setting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        setting.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            settings.append(setting)
        } catch let error as NSError  {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveOrdering() {
        for (index, setting) in self.settings.enumerate() {
            setting.setValue(index, forKey: "order")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
}
