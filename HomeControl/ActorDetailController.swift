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
        actor?.setValue(Int(actorScene.text!), forKey: "scene")
        actor?.setValue(actorDimmable.on, forKey: "dimmable")
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            print("Could not save the actor. Error: \(error)")
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
            actorScene.text = String(scene)
        }
        if let dimmable = actor!.dimmable {
            actorDimmable.setOn(Bool(dimmable), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveActor" {
            actor?.setValue(actorName.text, forKey: "name")
            actor?.setValue(actorUUID.text, forKey: "uuid")
            actor?.setValue(Int(actorScene.text!), forKey: "scene")
            actor?.setValue(actorDimmable.on, forKey: "dimmable")
            
            do {
                try managedObjectContext!.save()
            } catch let error as NSError {
                print("Could not save the actor. Error: \(error)")
            }
        }
    }

}
