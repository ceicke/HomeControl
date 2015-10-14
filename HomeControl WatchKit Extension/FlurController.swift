//
//  FlurController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import WatchKit
import Foundation

class FlurController: WKInterfaceController {
    
    let loxone = Loxone()
    
    @IBAction func flurAn() {
        loxone.tellLoxone("flurAn")
    }
    @IBAction func flurAus() {
        loxone.tellLoxone("flurAus")
    }
}
