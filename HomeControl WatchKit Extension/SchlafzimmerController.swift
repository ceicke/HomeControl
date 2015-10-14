//
//  SchlafzimmerController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation

class SchlafzimmerController: WKInterfaceController {
    
    let loxone = Loxone()
    
    var schlafzimmerStehleuchte:Bool = false
    
    @IBAction func schlafzimmerStehleuchteToggle() {
        if schlafzimmerStehleuchte {
            loxone.tellLoxone("schlafzimmerStehleuchteAus")
            schlafzimmerStehleuchte = false
        } else {
            loxone.tellLoxone("schlafzimmerStehleuchteAn")
            schlafzimmerStehleuchte = true
        }
    }
    
    @IBAction func schlafzimmerValueChanged(value: Float) {
        let roundedValue = Int(round(value))
        loxone.tellLoxone("dimmSchlafzimmer", dimmValue: roundedValue * 10)
    }
}