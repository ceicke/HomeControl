//
//  ActorController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 29.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import WatchKit

class ActorController: WKInterfaceController {
    
    let loxone = Loxone()
    
    var name : NSString = ""
    var uuid : NSString = ""
    var scene : NSString = ""
    var dimmable : Bool = false

    @IBAction func actorOn() {
        if !dimmable {
            loxone.tellLoxone(name, uuid:uuid, onOff: "on", scene: scene)
        } else {
            loxone.tellLoxone(name, uuid:uuid, onOff: "on", scene: scene, dimmValue: 100)
        }
        
        popController()
    }
    
    @IBAction func actorOff() {
        if !dimmable {
            loxone.tellLoxone(name, uuid:uuid, onOff: "off", scene: scene)
        } else {
            loxone.tellLoxone(name, uuid:uuid, onOff: "off", scene: scene, dimmValue: 0)
        }
        
        popController()
    }
    
    @IBOutlet var dimmer: WKInterfaceSlider!
    
    @IBAction func dimmerTouched(value: Float) {
        loxone.tellLoxone(name, uuid:uuid, onOff: "on", scene: scene, dimmValue: Int(value))
    }
    
    override func awakeWithContext(context: AnyObject?) {
        name = context!["name"] as! NSString
        uuid = context!["uuid"] as! NSString
        scene = context!["scene"] as! NSString
        
        if context!["dimmable"] as! NSString == "0" {
            dimmable = false
            dimmer.setHidden(true)
        } else {
            dimmable = true
            dimmer.setHidden(false)
        }
        
        self.setTitle(name as String)
    }
}