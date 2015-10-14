//
//  NoraController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation

class NoraController: WKInterfaceController {
    
    let loxone = Loxone()
    
    var banane:Bool = false
    var nachtlicht:Bool = false
    
    @IBAction func bananeToggle() {
        if banane {
            loxone.tellLoxone("bananeAus")
            banane = false
        } else {
            loxone.tellLoxone("bananeAn")
            banane = true
        }
    }
    
    @IBAction func nachtlichtToggle() {
        if nachtlicht {
            loxone.tellLoxone("nachtlichtAus")
            nachtlicht = false
        } else {
            loxone.tellLoxone("nachtlichtAn")
            nachtlicht = true
        }
    }

    @IBAction func deckenleuchte(value: Float) {
        let roundedValue = Int(round(value))
        loxone.tellLoxone("dimmNora", dimmValue: roundedValue * 10)
    }
}