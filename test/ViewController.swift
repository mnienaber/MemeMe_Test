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
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var shareOutlet: UIBarButtonItem!
    @IBOutlet weak var saveMemeOutlet: UIBarButtonItem!
    @IBOutlet weak var topFieldText: UITextField!
    @IBOutlet weak var bottomFieldText: UITextField!
    
    var meme: Meme!
    var savedIndex: Int? = nil

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topFieldText.defaultTextAttributes = memeTextAttributes
        bottomFieldText.defaultTextAttributes = memeTextAttributes
        topFieldText.text = "TOP TEXT"
        bottomFieldText.text = "BOTTOM TEXT"
        topFieldText.textAlignment = NSTextAlignment.Center
        bottomFieldText.textAlignment = NSTextAlignment.Center
        
        self.topFieldText.delegate = self
        self.bottomFieldText.delegate = self
        
        topFieldText.hidden = true
        bottomFieldText.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotificationsExpand()
        subscribeToKeyboardNotificationsCollapse()
        shareOutlet.enabled = false

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerRefactor(sourceTypeVar: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceTypeVar
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        imagePickerRefactor(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        imagePickerRefactor(UIImagePickerControllerSourceType.Camera)
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
        saveMemeOutlet.title = "Save"
        shareOutlet.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomFieldText.isFirstResponder() {
            
            bottomToolBar.hidden = true
            view.frame.origin.y -= getKeyboardHeight(notification) - 44
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        bottomToolBar.hidden = false
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotificationsExpand() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        saveMemeOutlet.enabled = true
    }
    
    func subscribeToKeyboardNotificationsCollapse() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        saveMemeOutlet.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func startOver() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        
        let meme = Meme(topString: topFieldText.text!, bottomString: bottomFieldText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        topNavBar.hidden = true
        bottomToolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomToolBar.hidden = false
        topNavBar.hidden = false
        return memedImage
    }
    
    @IBAction func saveMemeButton(sender: AnyObject) {

        switch saveMemeOutlet {
        case saveMemeOutlet where saveMemeOutlet.title == "Save":
            save(generateMemedImage())
            startOver()
        default:
            startOver()
        }
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let shareableMeme = [generateMemedImage()]
        let activityView = UIActivityViewController(activityItems: shareableMeme, applicationActivities: nil)
        presentViewController(activityView, animated: true, completion: nil)
        save(generateMemedImage())
        saveMemeOutlet.title = "Done"
    }

}


