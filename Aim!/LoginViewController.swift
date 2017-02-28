//
//  LoginViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-02-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let themeOrangeColor = hexStringToUIColor(hex: "#FF4A1C")
    let themePurpleColor = hexStringToUIColor(hex: "1A1423")

    @IBOutlet weak var aimLogoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailAddressEntryTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordCreateEntryTextField: UITextField!
    @IBOutlet weak var passwordConfirmEntryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set text entry rect & text tint:
        // (Call below line in every VC which needs textfield cursors to be theme orange)
        UITextField.appearance().tintColor = themeOrangeColor
        // Set delegate:
        emailAddressEntryTextField.delegate = self
        passwordCreateEntryTextField.delegate = self
        passwordConfirmEntryTextField.delegate = self
        
        // Button corner radius:
        signupButton.layer.cornerRadius = 7
        loginButton.layer.cornerRadius = 7
        signupButton.backgroundColor = themePurpleColor
        loginButton.backgroundColor = themePurpleColor
        
        signupButton.layer.shadowOpacity = 0.7
        signupButton.layer.shadowOffset = CGSize(width: 7.0, height: 5.0)
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.shadowOffset = CGSize(width: 7.0, height: 5.0)
        
        // Hide keyboard:
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailAddressEntryTextField {
            passwordCreateEntryTextField.becomeFirstResponder()
        } else if textField == passwordCreateEntryTextField {
            passwordConfirmEntryTextField.becomeFirstResponder()
        }
        
        return true
    }
    
//    func configureSelectedButtonShadow(selectedButton: UIButton) {
//        
//    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let signupButton = sender as! UIButton
        
            let bounds = signupButton.bounds
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                signupButton.bounds = CGRect(x: bounds.origin.x - 5, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
            }, completion: nil)
    }
    
    @IBAction func signupButtonReleased(_ sender: Any) {
        let signupButton = sender as! UIButton
        
        let bounds = signupButton.bounds
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            signupButton.bounds = CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
        }, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let loginButton = sender as! UIButton

        let bounds = loginButton.bounds
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            loginButton.bounds = CGRect(x: bounds.origin.x - 5, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
        }, completion: nil)
    }
    
    @IBAction func loginButtonReleased(_ sender: Any) {
        let loginButton = sender as! UIButton
        
        let bounds = loginButton.bounds
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            loginButton.bounds = CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
        }, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailAddressEntryTextField.text, let pwd1 = passwordCreateEntryTextField.text, let pwd2 = passwordConfirmEntryTextField.text else {
            print("Enter valid info.")
            return
        }
        
        if pwd1 == pwd2 {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd1, completion: { (user: FIRUser?, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                
                let reference = FIRDatabase.database().reference(fromURL: "https://aim-a3c43.firebaseio.com/")
                let userReference = reference.child("users").child(uid)
                let userInfoValues = ["Email" : email, "Password" : pwd1]
                userReference.updateChildValues(userInfoValues, withCompletionBlock: { (err, reference) in
                    if err != nil {
                        print(err)
                        return
                    }
                    print("User creation success.")
                })
                print("Registered new user.")
            })
        }
//        dismiss(animated: true, completion: nil)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
