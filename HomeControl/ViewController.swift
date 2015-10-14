//
//  ViewController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var loxoneServerUrl: UITextField!
    @IBOutlet weak var loxoneUsername: UITextField!
    @IBOutlet weak var loxonePassword: UITextField!
    
    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        
        if let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") as? NSString {
            loxoneServerUrl.text = loxoneLocalIP as String
        }
        if let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as? NSString {
            loxoneUsername.text = username as String
        }
        if let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as? NSString {
            loxonePassword.text = password as String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveValues(sender: UIButton) {
        if loxoneServerUrl.text!.isEmpty || loxoneUsername.text!.isEmpty || loxonePassword.text!.isEmpty {
            let alertController = UIAlertController(title: "Fehler", message: "Bitte Benutzername, Passwort und lokale IP des Miniservers eintragen", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(loxoneServerUrl.text!, forKey: "serverUrl")
            NSUserDefaults.standardUserDefaults().setObject(loxoneUsername.text!, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(loxonePassword.text!, forKey: "password")
            
            NSUserDefaults.standardUserDefaults().synchronize()

            let configurationData = ["serverUrl":String(loxoneServerUrl.text!), "username":String(loxoneUsername.text!), "password":String(loxonePassword.text!)]
            
            var title:NSString = "Alles klar"
            var message:NSString = "Die AppleWatch hat die Daten empfangen."
            
            if (WCSession.defaultSession().reachable) {
                session.sendMessage(configurationData, replyHandler: {(reply: [String : AnyObject]) -> Void in
                    }, errorHandler: {(error ) -> Void in
                        title = "Fehler"
                        message = "Fehler bei der Kommunikation mit der Apple Watch."
                })
            } else {
                title = "Fehler"
                message = "AppleWatch nicht in Reichweite."
            }
            
            let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

