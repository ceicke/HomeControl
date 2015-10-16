//
//  SettingController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 16.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class SettingController: UIViewController, UITableViewDataSource {
    
    var settings = [NSManagedObject]()
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBAction func addSetting(sender: AnyObject) {
        let alert = UIAlertController(title: "Neuer Aktor",
            message: "Neuen Aktor hinzufügen",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
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
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Aktoren"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        
        //3
        do {
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            settings = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //Replace both UITableViewDataSource methods
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return settings.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            
            let setting = settings[indexPath.row]
            
            cell!.textLabel!.text = setting.valueForKey("name") as? String
            
            return cell!
    }
    
    func saveSetting(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Actor", inManagedObjectContext:managedContext!)
        
        let setting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        setting.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext!.save()
            //5
            settings.append(setting)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
