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
    
    @IBAction func saveActor(sender: UIButton) {
        actor?.setValue(actorName.text, forKey: "name")
        actor?.setValue(actorUUID.text, forKey: "uuid")
        actor?.setValue(actorScene.text, forKey: "scene")
        actor?.setValue(actorDimmable.on, forKey: "dimmable")
        
        if (!isUUIDvalid((actor?.uuid)!)) {
            let alertController = UIAlertController(title: "Fehler", message: "Die eingegebene UUID hat das falsche Format.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("Could not save the actor. Error: \(error)")
        }
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func isUUIDvalid(uuid: String)-> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9]{4}-[0-9a-f]{4}-[0-9a-f]{16}$", options: [.CaseInsensitive])
        let textString = uuid as NSString
        let matches = regex.matchesInString(uuid, options: [], range: NSMakeRange(0, textString.length))
        
        return matches.count > 0
    }

}
