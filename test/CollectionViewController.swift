//
//  CollectionViewController.swift
//  MemeMe2
//
//  Created by Michael Nienaber on 16/01/2016.
//  Copyright © 2016 Michael Nienaber. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionViewCell

        let info = self.memes[indexPath.row]
        
        //cell.textLabel!.text = (info.topString + " " + info.bottomString)
        cell.imageView!.image = info.memedImage
        
        return cell
        
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showImage", sender: self)
        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailImageViewController") as! DetailImageViewController
     //   detailController.detailImageView = self.memes[indexPath.row]
     //   self.navigationController!.pushViewController(detailController, animated: true)
        
    //}
    
    
}
