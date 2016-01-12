//
//  MemeDetailView.swift
//  MemeMe2
//
//  Created by Michael Nienaber on 11/01/2016.
//  Copyright © 2016 Michael Nienaber. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailView: UIViewController {
    
    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Create",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "startOver")
    }
    
    func startOver() {
        
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
}
