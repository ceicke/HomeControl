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
        
        var lastStatusCode:Int
        var lastStatusCodeDate:NSDate
        var lastActor:String
        
        if NSUserDefaults.standardUserDefaults().objectForKey("lastStatusCode") == nil {
            lastStatusCode = -1
        } else {
            lastStatusCode = NSUserDefaults.standardUserDefaults().valueForKey("lastStatusCode") as! Int
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("lastStatusCodeDate") == nil {
            lastStatusCodeDate = NSDate()
        } else {
            lastStatusCodeDate = NSUserDefaults.standardUserDefaults().valueForKey("lastStatusCodeDate") as! NSDate
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("lastActor") == nil {
            lastActor = NSLocalizedString("NOTHING_SENT_YET", comment: "Noch nichts gesendet")
        } else {
            lastActor = (NSUserDefaults.standardUserDefaults().valueForKey("lastActor") as? String)!
        }
        
        lastResultLabel.setText(String(lastStatusCode))
        lastReusultActorLabel.setText(lastActor)
        
        let lastStatusCodeDateString = NSDateFormatter.localizedStringFromDate(lastStatusCodeDate, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        lastResultDateTimeLabel.setText(lastStatusCodeDateString)
        
    }
    
}