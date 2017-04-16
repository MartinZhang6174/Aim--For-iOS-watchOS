//
//  LoginViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-02-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

let themeOrangeColor = hexStringToUIColor(hex: "#FF4A1C")
let themePurpleColor = hexStringToUIColor(hex: "1A1423")

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loadingViewFrame = CGRect()
    var loadingViewType = NVActivityIndicatorType(rawValue: 10)
    var loadingViewPadding = CGFloat()
    let loadingViewUIBlockerSize = CGSize(width: 40, height: 40)

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
        
        // Configure loading view data
        loadingViewFrame = CGRect(x: self.view.center.x - 25, y: aimLogoImageView.frame.maxY + 10, width: 50, height: 50)
        
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
    
    func moveLoadingView(loadingView: NVActivityIndicatorView) {
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
    }
    
    func endLoadingView(movingLoadingView: NVActivityIndicatorView) {
        movingLoadingView.stopAnimating()
        movingLoadingView.removeFromSuperview()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        // Configuring loading view at this point in order to test TODO: move this to point where the info entered is valid and system establishing connections to Firebase.
        
        // If password confirming tf is hidden, show it first(with placeholder change to password creation tf)
        if passwordConfirmEntryTextField.isHidden == true {
            passwordCreateEntryTextField.placeholder = "Create your password"
            passwordConfirmEntryTextField.isHidden = false
            passwordConfirmEntryTextField.alpha = 0.7
        } else {
        
            // If password confirming tf ISN'T hidden (it's there), handle signup
        let loginLoadingView = NVActivityIndicatorView(frame: loadingViewFrame, type: NVActivityIndicatorType.ballRotate, color: themeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
//        moveLoadingView(loadingView: loginLoadingView)
        
        guard let email = emailAddressEntryTextField.text, let pwd1 = passwordCreateEntryTextField.text, let pwd2 = passwordConfirmEntryTextField.text else {
//            print("Enter valid info.")
            return
        }
        
        if pwd1 != "" && pwd1 == pwd2 {
            moveLoadingView(loadingView: loginLoadingView)
            print("Password match, point where loading view needed.")
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd1, completion: { (user: FIRUser?, error) in
                if error != nil {
                    self.endLoadingView(movingLoadingView: loginLoadingView)
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
                        self.endLoadingView(movingLoadingView: loginLoadingView)
                        print(err)
                        return
                    }
                    if FIRAuth.auth()?.currentUser?.uid != nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                    print("User creation success.")
                })
                print("Registered new user.")
            })
        } else {
            self.endLoadingView(movingLoadingView: loginLoadingView)
            print("Invalid info.")
            }
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        // If the password confirming textfield isn't hidden, hide it
        let loginLoadingView = NVActivityIndicatorView(frame: loadingViewFrame, type: NVActivityIndicatorType.ballRotate, color: themeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        if passwordConfirmEntryTextField.isHidden == false {
            UIView.animate(withDuration: 3.0) {
                self.passwordCreateEntryTextField.placeholder = "Enter your password"
                self.passwordConfirmEntryTextField.alpha = 0
            }
            passwordConfirmEntryTextField.isHidden = true
        } else {
            // If password confirming tf IS hidden, then handle log in
            moveLoadingView(loadingView: loginLoadingView)
            
            guard let email = emailAddressEntryTextField.text, let pwd = passwordCreateEntryTextField.text else {
                endLoadingView(movingLoadingView: loginLoadingView)
                print("Enter valid info.")
                return
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    self.endLoadingView(movingLoadingView: loginLoadingView)
                    print(error)
                }
                if FIRAuth.auth()?.currentUser?.uid != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
//        if FIRAuth.auth()?.currentUser?.uid != nil {
//        } else {
//            endLoadingView(movingLoadingView: loginLoadingView)
//        }
    }
    
    @IBAction func closeWindowButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
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
