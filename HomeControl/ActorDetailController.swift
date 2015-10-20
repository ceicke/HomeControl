//
//  ActorDetail.swift
//  HomeControl
//
//  Created by Christoph Eicke on 20.10.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import UIKit

class ActorDetailController: UIViewController {
    
    
    @IBOutlet weak var actorName: UITextField!
    @IBOutlet weak var actorUUID: UITextField!
    @IBOutlet weak var actorScene: UITextField!
    
    @IBAction func saveActor(sender: UIButton) {
        print("save")
    }
    
    var selectedActor: AnyObject? {
        didSet {
            print(selectedActor!.name)
        }
    }
    
    func configureView() {
        if let name = selectedActor!.name {
            actorName.text = name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
}
