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

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession!
    var selectedItem : Int = 0
    var pickerItemArr = [WKPickerItem]()
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
            populatePicker()
        }
    }
        
    @IBOutlet var roomPicker: WKInterfacePicker!
    
    @IBAction func pickerChanged(value: Int) {
        selectedItem = value
        nextButton.setTitle(pickerItemArr[value].title)
    }
    
    @IBOutlet var nextButton: WKInterfaceButton!
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        if segueIdentifier == "ShowActor" {
            return actorDictionary[pickerItemArr[selectedItem].title!]
        }
        return nil
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
            
            let tempDictionary = ["name" : actorName, "uuid" : actorParametersArray[0], "scene" : actorParametersArray[1], "dimmable" : actorParametersArray[2]]
            self.actorDictionary[actorName] = tempDictionary
        }
        
        populatePicker()
        
        dispatch_async(dispatch_get_main_queue()) {
            NSUserDefaults.standardUserDefaults().setObject(self.actorDictionary, forKey: "actorDictionary")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
    
    func populatePicker() {
        if Array(actorDictionary.keys).count == 0 {
            return
        }
        
        pickerItemArr = [WKPickerItem]()
        
        for(actorName) in Array(actorDictionary.keys) {
            let k = WKPickerItem()
            k.title = actorName
            pickerItemArr.append(k)
        }
        
        roomPicker?.setItems(pickerItemArr)
        roomPicker?.setSelectedItemIndex(selectedItem)
        nextButton.setTitle(pickerItemArr[selectedItem].title)
    }
}
