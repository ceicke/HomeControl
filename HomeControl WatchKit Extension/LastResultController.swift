//
//  LastResultController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 17.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import WatchKit

class LastResultController: WKInterfaceController, NSXMLParserDelegate {
    
    @IBOutlet var lastResultLabel: WKInterfaceLabel!
    @IBOutlet var lastResultDateTimeLabel: WKInterfaceLabel!
    @IBOutlet var lastReusultActorLabel: WKInterfaceLabel!

    override func willActivate() {
        super.willActivate()
        
        let lastStatusCode:Int = NSUserDefaults.standardUserDefaults().valueForKey("lastStatusCode") as! Int
        let lastStatusCodeDate:NSDate = NSUserDefaults.standardUserDefaults().valueForKey("lastStatusCodeDate") as! NSDate
        
        lastResultLabel.setText(String(lastStatusCode))
        lastReusultActorLabel.setText(NSUserDefaults.standardUserDefaults().valueForKey("lastActor") as? String)
        
        let lastStatusCodeDateString = NSDateFormatter.localizedStringFromDate(lastStatusCodeDate, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        lastResultDateTimeLabel.setText(lastStatusCodeDateString)
        
    }
    
}