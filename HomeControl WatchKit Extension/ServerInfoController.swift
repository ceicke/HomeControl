//
//  ServerInfoController.swift
//  HomeControl
//
//  Created by Christoph Eicke on 17.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import WatchKit

class ServerInfoController: WKInterfaceController, NSXMLParserDelegate {
    
    @IBOutlet var labelName: WKInterfaceLabel!
    @IBOutlet var labelVersion: WKInterfaceLabel!
    
    override func willActivate() {
        super.willActivate()
        getServerStatus()
    }
    
    
    func getServerStatus() {
    
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("serverUrl") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
    
        let url:NSURL = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/data/status")!
        
        let xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser!.delegate = self
        xmlParser!.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "Miniserver" {
            labelName.setText(attributeDict["Name"])
            labelVersion.setText(attributeDict["Version"])
        }
    }
    

}