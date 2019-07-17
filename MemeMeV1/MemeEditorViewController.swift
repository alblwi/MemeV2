//
//  ViewController.swift
//  MemeMeV1
//
//  Created by AHMED  on 13/04/2019.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet  var actionButton: UIBarButtonItem!
    @IBOutlet  var cancelButton: UIBarButtonItem!
    @IBOutlet  var topText: UITextField!
    @IBOutlet  var imagePickView: UIImageView!
    @IBOutlet  var camera: UIBarButtonItem!
    @IBOutlet  var bottomText: UITextField!
    @IBOutlet  var topToolBar: UIToolbar!
    @IBOutlet  var bottomToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.isEnabled = false
        setupTextField(topText, text: "TOP")
        setupTextField(bottomText, text: "BOTTOM")
        topText.delegate = self
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isEditing {
            //view.frame.origin.y = 0 - getKeyboardHeight(notification)
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    
   
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        
    }
    
    
    
    //Make keybord down when it dismissed
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomText.isEditing {
          //  view.frame.origin.y = 0 - getKeyboardHeight(notification)
            view.frame.origin.y = 0
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) // ->> use for check new new text after you return true
        textField.text = newText.uppercased()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func pickImage(_ sender: Any) {
        //let button = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        //imagePicker.sourceType = button.tag == 0 ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
//    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//    }
//

//    @IBAction func pickAnImageFromCamera(_ sender: Any) {
//        let button = sender as! UIBarButtonItem
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = button.tag == 0 ? .camera : .photoLibrary
//        //camera.isEnabled = UIImagePickerController.isSourceTypeAvailable
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        dismiss(animated: true, completion: nil)
    }


    @IBAction func cancelButton(_ sender: Any) {
        actionButton.isEnabled = false
        imagePickView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        dismiss(animated: true)
    }
    
    @IBAction func actionButtom(_ sender: Any) {
        let memeImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.save()
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickView.image!, memedImage: generateMemedImage())
        //(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true)
    }
    
    
    func generateMemedImage() -> UIImage {
        setToolbarState(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        setToolbarState(false)
        return memedImage
    }
    
    func setToolbarState(_ hidden: Bool) {
        topToolBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickView.image = image
            actionButton.isEnabled = true
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickView.image = image
            actionButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    

    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:UIColor.black ,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4]
}

