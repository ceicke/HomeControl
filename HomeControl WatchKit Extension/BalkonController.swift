//
//  BalkonController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation

class BalkonController: WKInterfaceController {
    
    let loxone = Loxone()
    
    var leuchte:Bool = false
    var qube:Bool = false
    
    @IBAction func leuchteToggle() {
        if leuchte {
            loxone.tellLoxone("balkonLeuchteAus")
            leuchte = false
        } else {
            loxone.tellLoxone("balkonLeuchteAn")
            leuchte = true
        }
    }
    
    @IBAction func qubeToggle() {
        if qube {
            loxone.tellLoxone("balkonQubeAus")
            qube = false
        } else {
            loxone.tellLoxone("balkonQubeAn")
            qube = true
        }
    }
}
