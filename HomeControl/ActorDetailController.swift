//
//  ActorDetail.swift
//  HomeControl
//
//  Created by Christoph Eicke on 20.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class ActorDetailController: UIViewController {
    
    var actor: Actor?
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var actorName: UITextField!
    @IBOutlet weak var actorUUID: UITextField!
    @IBOutlet weak var actorScene: UITextField!
    @IBOutlet weak var actorDimmable: UISwitch!
    
    @IBOutlet weak var testArea: UIView!
    @IBOutlet weak var testDimmer: UISlider!
    
    let loxone = Loxone()
    
    @IBAction func saveActor(sender: UIButton) {
        actor?.setValue(actorName.text, forKey: "name")
        actor?.setValue(actorUUID.text, forKey: "uuid")
        actor?.setValue(actorScene.text, forKey: "scene")
        actor?.setValue(actorDimmable.on, forKey: "dimmable")
        
        testDimmer.hidden = !actorDimmable.on
        
        if (!isUUIDFormatvalid((actor?.uuid)!)) {
            presentError(NSLocalizedString("ERROR", comment: "Fehler"), message: NSLocalizedString("WRONG_UUID_FORMAT", comment: "Die eingegebene UUID hat das falsche Format."))
            return
        }
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("Could not save the actor. Error: \(error)")
            presentError(NSLocalizedString("ERROR", comment: "Fehler"), message: NSLocalizedString("ACTOR_COULD_NOT_BE_SAVED", comment: "Der Aktor konnte nicht gespeichert werden."))
            return
        }
        
        if serverDataEntered((actor?.uuid)!) {
            testArea.hidden = false
        } else {
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    func configureView() {
        if let name = actor!.name {
            actorName.text = name
        }
        if let uuid = actor!.uuid {
            actorUUID.text = uuid
        }
        if let scene = actor!.scene {
            actorScene.text = scene
        }
        if let dimmable = actor!.dimmable {
            actorDimmable.setOn(Bool(dimmable), animated: true)
        }
        testArea.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func isUUIDFormatvalid(uuid: String)-> Bool {
        
        if actorUUID.text!.isEmpty {
            return false
        } else {
            let regex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{16}$", options: [.CaseInsensitive])
            let textString = uuid as NSString
            let matches = regex.matchesInString(uuid, options: [], range: NSMakeRange(0, textString.length))
        
            return matches.count > 0
        }
    }
    
    func serverDataEntered(uuid: String)-> Bool {
        if NSUserDefaults.standardUserDefaults().objectForKey("serverUrl") == nil || NSUserDefaults.standardUserDefaults().objectForKey("username") == nil || NSUserDefaults.standardUserDefaults().objectForKey("password") == nil {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func uuidChanged(sender: AnyObject) {
        testArea.hidden = true
    }
    @IBAction func sceneChanged(sender: AnyObject) {
        testArea.hidden = true
    }
    @IBAction func dimmableChanged(sender: AnyObject) {
        testArea.hidden = true
    }
    
    @IBAction func testOffPressed(sender: AnyObject) {
        testDimmer.value = 0
        if !actorDimmable.on {
            loxone.tellLoxone(actorName.text!, uuid:actorUUID.text!, onOff: "off", scene: actorScene.text!)
        } else {
            loxone.tellLoxone(actorName.text!, uuid:actorUUID.text!, onOff: "off", scene: actorScene.text!, dimmValue: 0)
        }
    }
    
    @IBAction func testOnPressed(sender: AnyObject) {
        testDimmer.value = 100
        if !actorDimmable.on {
            loxone.tellLoxone(actorName.text!, uuid:actorUUID.text!, onOff: "on", scene: actorScene.text!)
        } else {
            loxone.tellLoxone(actorName.text!, uuid:actorUUID.text!, onOff: "on", scene: actorScene.text!, dimmValue: 100)
        }
    }
    
    @IBAction func testDimmerTouched(dimmer: UISlider) {
        loxone.tellLoxone(actorName.text!, uuid:actorUUID.text!, onOff: "on", scene: actorScene.text!, dimmValue: Int(dimmer.value))
    }
    
    func presentError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
