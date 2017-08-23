//
//  AimSessionTitleChangeViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-14.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimSessionTitleChangeViewController: UIViewController {

    @IBOutlet weak var renamingLabel: UILabel!
    @IBOutlet weak var sessionTitleChangeTextField: UITextField!
    
    var ref: DatabaseReference?
    var currentSession: AimSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        if currentSession != nil {
            let sessionCurrentTitle = currentSession?.title
            renamingLabel.text = "Renaming session '\(sessionCurrentTitle!)':"
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if let session = currentSession {
            print(session.id)
            if sessionTitleChangeTextField.text != nil && sessionTitleChangeTextField.text != "" {
                ref?.child("users").child((Auth.auth().currentUser?.uid)!).child("Sessions").child(session.id).child("Title").setValue(sessionTitleChangeTextField.text!)
                self.dismiss(animated: true, completion: { 
                    let noti = AimStandardStatusBarNotification()
                    noti.display(withMessage: "Updating title, please refresh in a moment!", forDuration: 1.5)
                })
            } else {
                sessionTitleChangeTextField.shake()
                let warning = AimStandardStatusBarNotification()
                warning.display(withMessage: "Invalid entry, please try again.", forDuration: 1.5)
            }
        }
    }
}
