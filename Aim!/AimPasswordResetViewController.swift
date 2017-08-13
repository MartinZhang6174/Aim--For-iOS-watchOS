//
//  AimPasswordResetViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-30.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import BEMCheckBox
import Firebase

class AimPasswordResetViewController: UIViewController {

    @IBOutlet weak var passwordResetLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var successCheckBox: BEMCheckBox!
    @IBOutlet weak var failedImageView: UIImageView!
    
    var passwordResetLabelString: String?
    var emailLabelString: String?
    var isFBUser = true
    var isGoogleUser = true
    
    override func viewWillAppear(_ animated: Bool) {
        passwordResetLabel.text = passwordResetLabelString!
        emailLabel.text = emailLabelString!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFBUser || isGoogleUser {
            successCheckBox.isHidden = true
            successCheckBox.setOn(false, animated: false)
        } else {
            successCheckBox.isHidden = false
            failedImageView.isHidden = true
            
            if let currentUserEmail = Auth.auth().currentUser?.email {
                Auth.auth().sendPasswordReset(withEmail: currentUserEmail, completion: { (error) in
                    if error != nil {
                        print("Error sending password-reset email: \(error).")
                    }
                })
            }

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFBUser || isGoogleUser {
            successCheckBox.isHidden = true
        } else {
            successCheckBox.isHidden = false
            successCheckBox.setOn(true, animated: true)
        }
    }

    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
