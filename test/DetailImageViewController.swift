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
    
    var image: Meme!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.detailImageView!.image = image.memedImage
    }


}
