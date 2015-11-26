//
//  InterfaceController.swift
//  HomeControl WatchKit Extension
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

//
// TODO
// - show an error message when the GET call did not go through

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession!
    var actorDictionary : [String:Dictionary<String, String>] = [:]

    override func awakeWithContext(context: AnyObject?) {
        // This method is the entry point to our app
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if !loadConnectionSettings() {
            presentControllerWithName("NoSettingsFound", context: ["seague": "hierachical", "data": "Passed through page-based navigator"])
        } else {
            let sharedDefaults = NSUserDefaults.standardUserDefaults()
            sharedDefaults.synchronize()
            actorDictionary = sharedDefaults.valueForKey("actorDictionary") as! Dictionary
            loadTableData()
        }
    }
    
    @IBOutlet var actorTable: WKInterfaceTable!
    
    @IBAction func infoPressed() {
        presentControllerWithName("ServerInfo", context: ["seague": "hierachical", "data": "Passed through page-based navigator"])
    }
    
    @IBAction func lastResultPressed() {
        presentControllerWithName("LastResult", context: ["seague": "hierachical", "data": "Passed through page-based navigator"])
    }
    
    // receive and save basic connection settings
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        let serverUrl = message["serverUrl"] as? String
        let username = message["username"] as? String
        let password = message["password"] as? String
        
        dispatch_async(dispatch_get_main_queue()) {
            NSUserDefaults.standardUserDefaults().setObject(serverUrl, forKey: "serverUrl")
            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // receive and save actor settings
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let appData: Dictionary<String, String> = (applicationContext["appData"] as? Dictionary)!
        self.actorDictionary = [:]
        
        for(actorName, actorParameters) in appData {
            let actorParametersArray = actorParameters.componentsSeparatedByString(";")
            
            let tempDictionary = ["name" : actorName, "uuid" : actorParametersArray[0], "scene" : actorParametersArray[1], "dimmable" : actorParametersArray[2], "order" : actorParametersArray[3]]
            self.actorDictionary[actorName] = tempDictionary
        }
        
        loadTableData()
        
        dispatch_async(dispatch_get_main_queue()) {
            NSUserDefaults.standardUserDefaults().setObject(self.actorDictionary, forKey: "actorDictionary")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        var actorArray = Array(actorDictionary.keys)
        var _ = actorArray.sortInPlace() {
            var actor1 = actorDictionary[$0]
            var actor2 = actorDictionary[$1]
            return actor1!["order"] < actor2!["order"]
        }
        
        return actorDictionary[actorArray[rowIndex]]
    }
    
    func loadConnectionSettings() -> Bool {
        let sharedDefaults = NSUserDefaults.standardUserDefaults()
        sharedDefaults.synchronize()
        
        if (sharedDefaults.valueForKey("serverUrl") != nil && sharedDefaults.valueForKey("username") != nil && sharedDefaults.valueForKey("password") != nil && sharedDefaults.valueForKey("actorDictionary") != nil) {
            return true
        } else {
            return false
        }
    }
    
    func loadTableData() {
        if Array(actorDictionary.keys).count == 0 {
            return
        }
        
        var actorArray = Array(actorDictionary.keys)
        var _ = actorArray.sortInPlace() {
            var obj1 = actorDictionary[$0]
            var obj2 = actorDictionary[$1]
            return obj1!["order"] < obj2!["order"]
        }
        
        actorTable.setNumberOfRows(actorArray.count, withRowType: "ActorRowController")
        
        for (index, actorName) in actorArray.enumerate() {
            
            if let row = actorTable.rowControllerAtIndex(index) as? ActorRowController {
                row.actorName.setText(actorName)
                
                let alphaValue = 1.2 - Double(abs(Double(index) - Double(actorArray.count - 1) / 2 ) / Double(actorArray.count / 2))
                
                let color : UIColor = UIColor.init(red: 0, green: 0.53, blue: 0.46, alpha: CGFloat(alphaValue))
                row.actorGroup.setBackgroundColor(color)
            }
        }
    }
}
