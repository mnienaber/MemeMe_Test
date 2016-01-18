//
//  DetailImageViewController.swift
//  MemeMe2
//
//  Created by Michael Nienaber on 16/01/2016.
//  Copyright © 2016 Michael Nienaber. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailImageView.image = self.image
        
    
    }
}
