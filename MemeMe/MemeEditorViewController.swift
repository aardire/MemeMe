//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrew Ardire on 7/26/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Properties  
    
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    // MARK: generateMemedImage
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        configureBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        configureBars(false)
        
        return memedImage
    }
    
    func configureBars(_ input:Bool) {
        self.navigationController?.isNavigationBarHidden = input
        self.navigationController?.isToolbarHidden = input
        
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareButton.isEnabled = (pickImageView.image != nil)
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //top
        
        configureText(textField: textFieldTop, defaultText: "TOP")
        
        //bottom
        
        configureText(textField: textFieldBottom, defaultText: "BOTTOM")
        
    }
    
    // MARK: configureText
    
    func configureText(textField: UITextField, defaultText: String) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.delegate = self
    }
    
    //MARK: pickImageFromAlbum
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickAnImageFrom(.photoLibrary)
    }
    
    // MARK: pickImageFrom Camera
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickAnImageFrom(.camera)
    }
    
    // MARK: pickImageFrom
    
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: imagePickerController
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: imagePickerControllerDidCancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: textfieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: memeTextAttributes
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5
    ]
    
    // MARK:subscribeToKeyboardNotifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK:unsubscribeFromKeyboardNotifications
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK:keyboardWillShow
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    // MARK:keyboardWillHide
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    // MARK: getKeyboardHeight
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: textFieldDidBeginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
        if textField == textFieldTop {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    // MARK: textFieldDidEndEditing
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldTop {
            subscribeToKeyboardNotifications()
        }
    }
    
    // MARK: share
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler =
            { (activityType, completed, returnedItems, error) in
                // Create the meme
                
                let newMeme = Meme(topText: self.textFieldTop.text!, bottomText: self.textFieldBottom.text!, originalImage: self.pickImageView.image!, memedImage: memedImage)
                
                // Add it to the memes array in the Application Delegate
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(newMeme)
        }
    }
    
    
    
}


