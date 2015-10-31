//
//  Actor+CoreDataProperties.swift
//  HomeControl
//
//  Created by Christoph Eicke on 28.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Actor {

    @NSManaged var name: String?
    @NSManaged var uuid: String?
    @NSManaged var scene: String?
    @NSManaged var dimmable: NSNumber?

}
