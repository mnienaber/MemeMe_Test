//
//  ViewController.swift
//  test
//
//  Created by Michael Nienaber on 9/12/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//
import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topFieldText: UITextField!
    @IBOutlet weak var bottomFieldText: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var shareOutlet: UIBarButtonItem!
    @IBOutlet weak var saveMemeOutlet: UIBarButtonItem!

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topFieldText.textAlignment = NSTextAlignment.Center
        bottomFieldText.textAlignment = NSTextAlignment.Center
        topFieldText.defaultTextAttributes = memeTextAttributes
        bottomFieldText.defaultTextAttributes = memeTextAttributes
        topFieldText.text = "TOP TEXT"
        bottomFieldText.text = "BOTTOM TEXT"
        
        self.topFieldText.delegate = self
        self.bottomFieldText.delegate = self
        
        topFieldText.hidden = true
        bottomFieldText.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotificationsExpand()
        self.subscribeToKeyboardNotificationsCollapse()

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerRefactor(sourceTypeVar: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceTypeVar
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        self.imagePickerRefactor(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        self.imagePickerRefactor(UIImagePickerControllerSourceType.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        topFieldText.hidden = false
        bottomFieldText.hidden = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomFieldText.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotificationsExpand() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        saveMemeOutlet.enabled = false
    }
    
    func subscribeToKeyboardNotificationsCollapse() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        saveMemeOutlet.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    struct Meme {
        var topString: String
        var bottomString: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    func save(memedImage: UIImage) {
        
        let leMeme = Meme(topString: topFieldText.text!, bottomString: bottomFieldText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
    }
    
    @IBAction func saveMemeButton(sender: AnyObject) {
        
        self.save(generateMemedImage())
        self.savedImageAlert()
    }
    
    func generateMemedImage() -> UIImage {
        
        self.topNavBar.hidden = true
        self.bottomToolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.bottomToolBar.hidden = false
        self.topNavBar.hidden = false
        return memedImage
    }
    
    func savedImageAlert() {
        
        let alert = UIAlertController(title: "Done!", message: "Saved to your Camera Roll. \n\nShare it with your friends!", preferredStyle: .Alert)
        let oKAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
        }
        alert.addAction(oKAction)
        self.presentViewController(alert, animated: true, completion: nil)
        print("yes")
        
        
        //alert.title = "Done!"
        //alert.message = "Your meme was saved to your Camera Roll. \n\nShare it with your friends!"
        //alert.delegate = self
        //alert.addButtonWithTitle("OK")
        //alert.show()
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let shareableMeme = [self.generateMemedImage()]
        let activityView = UIActivityViewController(activityItems: shareableMeme, applicationActivities: nil)
        self.presentViewController(activityView, animated: true, completion: nil)
        self.save(generateMemedImage())
    }

}


