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

class AimSessionAddingPopupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var aimSessionTitleTextField: UITextField!
    @IBOutlet weak var aimSessionPrioritySwitch: UISwitch!
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    
    // var sessionObject: AimSession?
    let imagePicker = UIImagePickerController()
    let databaseRef = Database.database().reference(fromURL: "https://aim-a3c43.firebaseio.com/")
    var sessionImageSelected: UIImage?
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        // sessionObject = AimSession(sessionTitle: "", dateInitialized: nil, image: nil, priority: false)
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
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
                        
                        self.handleSessionCreationWithImageID(imageID: sessionTitle, values: sessionInfoValue)
                    }
                    
                })
            }
            
            // (withPath: "Users/\(uid))/SessionImages/(\(identifier.description)).jpg")
            
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            // putData method seems to only take in Data type?
            /*let uploadTask = storageRef.putData(uploadData!, metadata: uploadMetadata) { (metadata, error) in
             if (error != nil) {
             print("\(String(describing: error?.localizedDescription))")
             } else {
             print("\(String(describing: metadata))")
             }
             }
             uploadTask.observe(.progress) { [weak self] (snapshot) in
             guard let progress = snapshot.progress else { return }
             self?.imageUploadProgressView.progress = Float(progress.fractionCompleted)
             }
             }*/
        }
        
    }
    
    private func handleSessionCreationWithImageID(imageID: String?, values: [String: Any]) {
        
        if let sessionTitle = aimSessionTitleTextField.text {
            
            if let currentUserID = Auth.auth().currentUser?.uid {
                databaseRef.child("users/\(currentUserID)/Sessions/\(sessionTitle)").setValue(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print("Error occured uploading session: \(String(describing: error?.localizedDescription))")
                    } else {
                        print("Successfully uploaded session.")
                        
                        /*if self.sessionImageSelected != nil {
                         self.uploadSessionImageToFirebaseStorageWithID(identifier: sessionID)
                         }*/
                    }
                })
                
            }
        }
        
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
