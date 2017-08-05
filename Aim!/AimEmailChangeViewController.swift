//
//  AimEmailChangeViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimEmailChangeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newEmailConfirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newEmailTextField.delegate = self
        newEmailConfirmTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        UITextField.appearance().tintColor = aimApplicationThemeOrangeColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // CODEREVIEW: resignFirstResponder and becomeFirstResponder return bool results which you are ignoring.  What happens if they fail?
        
        // RESEARCH ON RESIGNFIRSTRESPONDER AND FIND A WAY TO SAFELY CALL METHOD
        
        textField.resignFirstResponder()
        if textField == newEmailTextField {
            newEmailConfirmTextField.becomeFirstResponder()
        } else if textField == newEmailConfirmTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            self.view.endEditing(true)
        }
        return true
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        guard let newEmail = newEmailTextField.text, let newEmailConfirmed = newEmailConfirmTextField.text else {
            return }
        
        if newEmail != "" && newEmailConfirmed != "" && newEmail == newEmailConfirmed && passwordTextField.text != "" {
            
            
            let user = Auth.auth().currentUser
            let email = Auth.auth().currentUser?.email
            let password = passwordTextField.text
            let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    print(error)
                    self.passwordTextField.shake()
                    let warning = AimStandardStatusBarNotification()
                    warning.display(withMessage: "Wrong password provided, please check again.", forDuration: 1.5)
                } else {
                    Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (err) in
                        if error != nil {
                            print(err)
                            self.newEmailTextField.shake()
                            self.newEmailConfirmTextField.shake()
                            let warning = AimStandardStatusBarNotification()
                            warning.display(withMessage: "Something went wrong with your entries, please check again.", forDuration: 1.5)
                        }
                    })
                    self.dismiss(animated: true, completion: {
                        let noti = AimStandardStatusBarNotification()
                        noti.display(withMessage: "New email address set!", forDuration: 1.5)
                    })
                }
            })
        }
        
        if newEmail == "" || newEmailConfirmed == "" {
            newEmailTextField.shake()
            newEmailConfirmTextField.shake()
            let warning = AimStandardStatusBarNotification()
            warning.display(withMessage: "Invalid empty entry. Please try again.", forDuration: 1.5)
        }
        
        if newEmail != newEmailConfirmed {
            newEmailConfirmTextField.shake()
            let warning = AimStandardStatusBarNotification()
            warning.display(withMessage: "The two emails you entered don't match, please check again.", forDuration: 1.5)
        }
    }
}
