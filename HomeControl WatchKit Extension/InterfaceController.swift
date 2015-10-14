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
        
        if !loadSettings() {
            presentControllerWithName("NoSettingsFound", context: ["seague": "hierachical", "data": "Passed through page-based navigator"])
        }
    }
        
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    let loxone = Loxone()

    @IBAction func filmPressed() {
        loxone.tellLoxone("film")
    }
    @IBAction func chillPressed() {
        loxone.tellLoxone("chill")
    }
    @IBAction func essenPressed() {
        loxone.tellLoxone("essen")
    }
    @IBAction func kochenPressed() {
        loxone.tellLoxone("kochen")
    }
    @IBAction func wohnzimmerAus() {
        loxone.tellLoxone("wohnzimmerAus")
    }
    
    func loadSettings() -> Bool {
        let sharedDefaults = NSUserDefaults.standardUserDefaults()
        sharedDefaults.synchronize()
        
        if (sharedDefaults.valueForKey("serverUrl") != nil && sharedDefaults.valueForKey("username") != nil && sharedDefaults.valueForKey("password") != nil) {
            return true
        } else {
            return false
        }
    }
}
