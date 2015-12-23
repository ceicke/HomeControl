//
//  MainTabController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 27.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity
import CoreData

class MainTabController: UITabBarController, WCSessionDelegate {
    
    var session: WCSession!
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    
        addCenterButtonWithImage()
    }
    
    func addCenterButtonWithImage() {
        
        let frame = CGRectMake(0.0, 0.0, 100, 100)
        
        button = UIButton(frame: frame)
        
        let buttonImage = UIImage(named: "Send-to-watch")
        let buttonImageDisabled = UIImage(named: "Send-to-watch-disabled")
        
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.setBackgroundImage(buttonImageDisabled, forState: UIControlState.Disabled)
        
        let heightDifference:CGFloat = 100 - self.tabBar.frame.size.height
        
        if heightDifference < 0 {
            button.center = self.tabBar.center;
        } else {
            var center:CGPoint = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        
        button.addTarget(self, action: "sendConfigurationToWatch:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }
    
    func sendConfigurationToWatch(sender: UIButton) {
        
        if serverDataEntered() {
        
            let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") as! NSString
            let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
            let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
            
            let configurationData = ["serverUrl":loxoneLocalIP, "username":username, "password":password]
            
            var title:NSString = NSLocalizedString("ALLES_KLAR", comment: "Alles klar")
            var message:NSString = NSLocalizedString("APPLE_WATCH_RECEIVED_DATA", comment: "Die AppleWatch hat die Daten empfangen.")
            
            if (WCSession.defaultSession().reachable) {
                session.sendMessage(configurationData, replyHandler: {(reply: [String : AnyObject]) -> Void in
                    }, errorHandler: {(error ) -> Void in
                        title = NSLocalizedString("ERROR", comment: "Fehler")
                        message = NSLocalizedString("ERROR_COMMUNICATING_WITH_WATCH", comment: "Fehler bei der Kommunikation mit der Apple Watch.")
                })
                
                var actorData = Dictionary<String, String>()
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDelegate.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Actor")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
                
                var actors  = [Actor]()
                actors = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Actor]
                if actors.count > 0 {
                    for actor in actors {
                        if (actor.uuid != nil) {
                            actorData[actor.name!] = actor.asTransmittableString()
                        }
                    }
                } else {
                    NSLog("Could not find any Actor entities in the context")
                }
                
                try! session.updateApplicationContext(["appData" : actorData])
                
            } else {
                title = NSLocalizedString("ERROR", comment: "Fehler")
                message = NSLocalizedString("PLEASE_OPEN_LOXHOMECONTROL_ON_WATCH", comment: "Bitte LoxHomeControl auf der AppleWatch öffnen.")
            }
            
            let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("ERROR", comment: "Fehler"), message: NSLocalizedString("ENTER_BASIC_DATA", comment: "Bitte Benutzername, Passwort und lokale IP des Miniservers eintragen"), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func serverDataEntered() -> Bool {
        if NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") == nil || NSUserDefaults.standardUserDefaults().valueForKey("username") == nil || NSUserDefaults.standardUserDefaults().valueForKey("password") == nil {
            return false
        } else {
            return true
        }
    }
}