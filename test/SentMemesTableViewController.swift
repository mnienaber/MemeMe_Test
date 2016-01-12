//
//  SentMemesTableViewController.swift
//  MemeMe2
//
//  Created by Michael Nienaber on 21/12/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.memes = applicationDelegate.memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)
        let info = self.memes[indexPath.row]
        
        cell.textLabel!.text = info.topString
        cell.detailTextLabel!.text = info.bottomString
        cell.imageView!.image = info.memedImage
        
        return cell
        
    }

}
