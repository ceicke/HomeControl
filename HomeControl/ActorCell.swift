//
//  ActorCell.swift
//  HomeControl
//
//  Created by Christoph Eicke on 18.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import UIKit

class ActorCell: UITableViewCell {
    
    @IBOutlet weak var actorName: UILabel!
    
    func configure(name: String?) {
        actorName.text = name
    }
    
}