//
//  ViewController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var loxoneServerUrl: UITextField!
    @IBOutlet weak var loxoneUsername: UITextField!
    @IBOutlet weak var loxonePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func saveValues(sender: UIButton) {
        if loxoneServerUrl.text!.isEmpty || loxoneUsername.text!.isEmpty || loxonePassword.text!.isEmpty {
            let alertController = UIAlertController(title: NSLocalizedString("ERROR", comment: "Fehler"), message: NSLocalizedString("ENTER_BASIC_DATA", comment: "Bitte Benutzername, Passwort und lokale IP des Miniservers eintragen"), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(loxoneServerUrl.text!, forKey: "serverUrl")
            NSUserDefaults.standardUserDefaults().setObject(loxoneUsername.text!, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(loxonePassword.text!, forKey: "password")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        MainTabController().enableDisableSendButton()
    }
}

