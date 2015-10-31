//
//  Loxone.swift
//  HomeControl
//
//  Created by Christoph Eicke on 10.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation

struct Loxone {
    func tellLoxone(uuid:NSString, onOff:NSString, scene:NSString = "", dimmValue:Int = -1) {
        
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        var url:NSURL = NSURL(string: "")!
        
        if scene == "" {
            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(onOff)")!
        } else {
            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(scene)/\(onOff)")!
        }
        
        if url != "" {
            print(url)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                print(data, response)
            }
            
            task.resume()
        }
        
//        if what == "film"  {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3d50-0261-72a7-ffff3d2ae26d22b5/1")!
//        }
//        if what == "chill"  {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3d50-0261-72a7-ffff3d2ae26d22b5/2")!
//        }
//        if what == "essen"  {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3d50-0261-72a7-ffff3d2ae26d22b5/3")!
//        }
//        if what == "kochen"  {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3d50-0261-72a7-ffff3d2ae26d22b5/4")!
//        }
//        if what == "wohnzimmerAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3d50-0261-72a7-ffff3d2ae26d22b5/off")!
//        }
//        if what == "flurAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85ae35-0261-72da-ffff504f94000000/AI1/on")!
//        }
//        if what == "flurAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85ae35-0261-72da-ffff504f94000000/AI1/off")!
//        }
//        if what == "schlafzimmerStehleuchteAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d4059-032c-cb2f-ffff504f94000000/AI2/on")!
//        }
//        if what == "schlafzimmerStehleuchteAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d4059-032c-cb2f-ffff504f94000000/AI2/off")!
//        }
//        if what == "dimmSchlafzimmer" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d4059-032c-cb2f-ffff504f94000000/AI1/\(dimmValue)")!
//        }
//        if what == "badDeckeAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c89a333-0148-fd76-ffffee4f608444ec/AI1/on")!
//        }
//        if what == "badDeckeAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c89a333-0148-fd76-ffffee4f608444ec/AI1/off")!
//        }
//        if what == "badSpiegelAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c89a333-0148-fd76-ffffee4f608444ec/AI2/on")!
//        }
//        if what == "badSpiegelAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c89a333-0148-fd76-ffffee4f608444ec/AI2/off")!
//        }
//        if what == "balkonLeuchteAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3ffb-01e4-a931-ffff5a506f83a129/on")!
//        }
//        if what == "balkonLeuchteAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3ffb-01e4-a931-ffff5a506f83a129/off")!
//        }
//        if what == "balkonQubeAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3fed-01a5-9f6a-fffff6b94b36fdc7/on")!
//        }
//        if what == "balkonQubeAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c2d3fed-01a5-9f6a-fffff6b94b36fdc7/off")!
//        }
//        if what == "bananeAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85abb2-00cb-9be3-ffff504f94000000/AI2/on")!
//        }
//        if what == "bananeAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85abb2-00cb-9be3-ffff504f94000000/AI2/off")!
//        }
//        if what == "nachtlichtAn" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85abb2-00cb-9be3-ffff504f94000000/AI3/on")!
//        }
//        if what == "nachtlichtAus" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85abb2-00cb-9be3-ffff504f94000000/AI3/off")!
//        }
//        if what == "dimmNora" {
//            url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/0c85abb2-00cb-9be3-ffff504f94000000/AI1/\(dimmValue)")!
//        }
        

    }
}