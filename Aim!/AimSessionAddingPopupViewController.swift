//
//  AimSessionAddingPopupViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-23.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

class AimSessionAddingPopupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var aimSessionTitleTextField: UITextField!
    @IBOutlet weak var aimSessionPrioritySwitch: UISwitch!
    @IBOutlet weak var aimSessionAddingPageView: UIView!
    @IBOutlet weak var sessionDemoView: UIView!
    @IBOutlet weak var sessionDemoImageView: UIImageView!
    @IBOutlet weak var sessionDemoLabel: UILabel!
    
    // var sessionObject: AimSession?
    let imagePicker = UIImagePickerController()
    let databaseRef = Database.database().reference(fromURL: "https://aim-a3c43.firebaseio.com/")
    var sessionImageSelected: UIImage?
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        aimSessionTitleTextField.delegate = self
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        // sessionObject = AimSession(sessionTitle: "", dateInitialized: nil, image: nil, priority: false)
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.

//        aimSessionAddingPageView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionDemoView.clipsToBounds = true
        sessionDemoView.layer.cornerRadius = 5.0
        
        aimSessionAddingPageView.layer.cornerRadius = 7.0
        aimSessionAddingPageView.clipsToBounds = true
        
        aimSessionAddingPageView.layer.shadowOpacity = 1.0
        aimSessionAddingPageView.layer.shadowRadius = 5.0
        aimSessionAddingPageView.layer.shadowColor = UIColor.white.cgColor
        aimSessionAddingPageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        aimSessionAddingPageView.layer.shadowPath = CGPath(ellipseIn: CGRect(x: -10, y: -20, width: 50, height: 50), transform: nil)
    }
    
    @IBAction func sessionImageAddButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Please Choose Your Photo Source", message: "You can either take a picture using your camera or pick one from your photo library.", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let libraryAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == "" {
            return false
        } else {
            sessionDemoLabel.text = textField.text
            textField.resignFirstResponder()
            return true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            sessionImageSelected = selectedImage
        }
        
        // let picID = NSUUID.
        // uploadSessionImageToFirebaseStorageWithID(identifier: "", values: ["Title":"Chilling"])
        
        sessionDemoImageView.image = sessionImageSelected
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picking canceled.")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sessionAddingConfirmButtonClicked(_ sender: Any) {
        handleSessionUpload()
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleSessionUpload() {
        
        let sessionTitle = aimSessionTitleTextField.text
        let sessionPriority = aimSessionPrioritySwitch.isOn
        let sessionPriorityString: String?
        if sessionPriority == true {
            sessionPriorityString = "1"
        } else if sessionPriority == false {
            sessionPriorityString = "0"
        } else {
            sessionPriorityString = "0"
        }
        
        // let sessionImage = sessionImageSelected
        
        let sessionCreationDate = Date()
        let formattedCreationDate = formatter.string(from: sessionCreationDate)
        
        let sessionID = NSUUID.init().uuidString
        if let uid = Auth.auth().currentUser?.uid {
            let storageRef = Storage.storage().reference().child("Users").child(uid).child("SessionImages").child("\(sessionID).png")
            if let uploadData = UIImagePNGRepresentation(sessionImageSelected!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("Error occured when adding image to storage: \(String(describing: error))")
                        return
                    }
                    
                    if let sessionImageURL = metadata?.downloadURL()?.absoluteString {
                        
                        let sessionInfoValue = ["DateCreated": formattedCreationDate, "Priority": sessionPriorityString, "ImageURL": sessionImageURL]
                        
                        if sessionInfoValue["ImageURL"] != nil && sessionTitle != nil {
                            self.handleSessionCreationWithImageID(imageID: sessionTitle, values: sessionInfoValue)
                        }
                        
                    }
                })
                
            }
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
        }
        
    }
    
    private func handleSessionCreationWithImageID(imageID: String?, values: [String: Any]) {
        
        if let sessionTitle = aimSessionTitleTextField.text {
            
            if let currentUserID = Auth.auth().currentUser?.uid {
                databaseRef.child("users/\(currentUserID)/Sessions/\(sessionTitle)").setValue(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print("Error occured uploading session: \(String(describing: error?.localizedDescription))")
                        return
                    } else {
                        print("Successfully uploaded session.")
                    }
                })
                
            }
        }
        
    }
    
    @IBAction func closeSessionAddingPopupButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
