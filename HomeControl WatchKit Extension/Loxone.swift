//
//  Loxone.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import WatchKit

class Loxone {
    
    func tellLoxone(actor:NSString, uuid:NSString, onOff:NSString, scene:NSString = "", dimmValue:Int = -1) {
        
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        var url:NSURL = NSURL(string: "")!
        
        if scene == "" {
            if dimmValue == -1 {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(onOff)")!
            } else {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(dimmValue)")!
            }
        } else {
            if dimmValue == -1 {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(scene)/\(onOff)")!
            } else {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(scene)/\(dimmValue)")!
            }
        }
        
        if url != "" {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    NSUserDefaults.standardUserDefaults().setObject(httpResponse.statusCode, forKey: "lastStatusCode")
                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastStatusCodeDate")
                    NSUserDefaults.standardUserDefaults().setObject(actor, forKey: "lastActor")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    if httpResponse.statusCode != 200 {
                        WKInterfaceDevice().playHaptic(.Failure)
                        NSLog("ERROR \(httpResponse.statusCode)")
                    }
                }
            }
            
            task.resume()
        }
    }
}