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
    var dimmable : NSString = ""

    @IBAction func actorOn() {
        loxone.tellLoxone(uuid, onOff: "on")
    }
    
    @IBAction func actorOff() {
        loxone.tellLoxone(uuid, onOff: "off")
    }
    
    
    @IBOutlet var dimmer: WKInterfaceSlider!
    
    override func awakeWithContext(context: AnyObject?) {
        name = context!["name"] as! NSString
        uuid = context!["uuid"] as! NSString
        scene = context!["scene"] as! NSString
        dimmable = context!["dimmable"] as! NSString
        
        dimmer.setHidden(true)
        
        self.setTitle(name as String)
    }
}