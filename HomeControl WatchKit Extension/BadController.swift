//
//  Bad.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation

class BadController: WKInterfaceController {
    
    let loxone = Loxone()
    
    var badSpiegel:Bool = false
    var badDecke:Bool = false
    
    @IBAction func badSpiegelToggle() {
        if badSpiegel {
            loxone.tellLoxone("badSpiegelAus")
            badSpiegel = false
        } else {
            loxone.tellLoxone("badSpiegelAn")
            badSpiegel = true
        }
    }
    
    @IBAction func badDeckeToggle() {
        if badDecke {
            loxone.tellLoxone("badDeckeAus")
            badDecke = false
        } else {
            loxone.tellLoxone("badDeckeAn")
            badDecke = true
        }
    }
}