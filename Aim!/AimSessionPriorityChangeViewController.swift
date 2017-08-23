//
//  AimSessionPriorityChangeViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-15.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimSessionPriorityChangeViewController: UIViewController {
    
    @IBOutlet weak var sessionPriorityLabel: UILabel!
    @IBOutlet weak var sessionPrioritySwitch: UISwitch!
    
    var currentSession: AimSession?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if let session = currentSession {
            sessionPriorityLabel.text = "Modifying Priority Setting for '\(session.title)':"
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            if let session = currentSession {
                if sessionPrioritySwitch.isOn {
                    ref?.child("users/\(currentUserId)/Sessions/\(session.id)/Priority").setValue("1")
                } else {
                    ref?.child("users/\(currentUserId)/Sessions/\(session.id)/Priority").setValue("0")
                }
                self.dismiss(animated: true, completion: { 
                    let noti = AimStandardStatusBarNotification()
                    noti.display(withMessage: "Updating priority, please refresh in a moment!", forDuration: 1.5)
                })
            }
        }
    }
}
