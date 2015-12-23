//
//  Actor.swift
//  HomeControl
//
//  Created by Christoph Eicke on 28.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import CoreData

class Actor: NSManagedObject {
    
    func asTransmittableString() -> String {
        return "\(uuid!);\(scene!);\(dimmable!);\(order!)"
    }
    
    func isUUIDFormatvalid() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{16}$", options: [.CaseInsensitive])
        let textString = uuid! as NSString
        let matches = regex.matchesInString(uuid!, options: [], range: NSMakeRange(0, textString.length))
        
        return matches.count > 0
    }
    
    
}
