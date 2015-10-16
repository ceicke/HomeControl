//
//  SettingController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 16.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit

class SettingController: UIViewController, UITableViewDataSource {
    
    var settings = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBAction func addSetting(sender: AnyObject) {
        let alert = UIAlertController(title: "Neuer Aktor",
            message: "Neuen Aktor hinzufügen",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Speichern",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.settings.append(textField!.text!)
                print(self.settings)
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
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return settings.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = settings[indexPath.row]
            
            return cell!
    }
}
