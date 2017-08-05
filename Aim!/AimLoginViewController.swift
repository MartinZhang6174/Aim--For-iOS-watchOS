//
//  AimLoginViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-02-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import WatchConnectivity
import FacebookLogin
import FBSDKLoginKit

// CODEREVIEW: These colours are used in other places.  Consider creating a Palette class or a UIColor extension to hold all the colours you use in one place.

let themeOrangeColor = hexStringToUIColor(hex: "#FF4A1C")
let themePurpleColor = hexStringToUIColor(hex: "1A1423")

class AimLoginViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    var loadingViewFrameRect = CGRect()
    var loadingViewType = NVActivityIndicatorType(rawValue: 10)
    var loadingViewPadding = CGFloat()
    let loadingViewUIBlockerSize = CGSize(width: 40, height: 40)
    let signUpButtonLayerCornerRadius = CGFloat(7.0)
    let signUpButtonLayerShadowOpacity = Float(0.7)
    let logInButtonLayerShadowOffsetWidth = Double(7.0)
    let logInButtonLayerShadowOffsetHeight = Double(5.0)
    
    @IBOutlet weak var aimLogoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailAddressEntryTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordCreateEntryTextField: UITextField!
    @IBOutlet weak var passwordConfirmEntryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring Facebook login button
        let fBLoginButton = LoginButton(readPermissions: [.publicProfile, .email])
        fBLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fBLoginButton)
        let fBLoginTopConstraint = fBLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 17)
        let fBLoginBottomConstraint = fBLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([fBLoginTopConstraint, fBLoginBottomConstraint])
        
        fBLoginButton.delegate = self
        
        // Set text entry rect & text tint:
        // (Call below line in every VC which needs textfield cursors to be theme orange)
        UITextField.appearance().tintColor = themeOrangeColor
        // Set delegate:
        emailAddressEntryTextField.delegate = self
        passwordCreateEntryTextField.delegate = self
        passwordConfirmEntryTextField.delegate = self
        
        // Button corner radius:
        signupButton.layer.cornerRadius = signUpButtonLayerCornerRadius
        loginButton.layer.cornerRadius = signUpButtonLayerCornerRadius
        signupButton.backgroundColor = themePurpleColor
        loginButton.backgroundColor = themePurpleColor
        
        // Button shadow configurations:
        signupButton.layer.shadowOpacity = signUpButtonLayerShadowOpacity
        loginButton.layer.shadowOpacity = signUpButtonLayerShadowOpacity
        signupButton.layer.shadowOffset = CGSize(width: logInButtonLayerShadowOffsetWidth, height: logInButtonLayerShadowOffsetHeight)
        loginButton.layer.shadowOffset = CGSize(width: logInButtonLayerShadowOffsetWidth, height: logInButtonLayerShadowOffsetHeight)
        
        // Configure loading view data:
        loadingViewFrameRect = CGRect(x: self.view.center.x - 25, y: aimLogoImageView.frame.maxY + 10, width: 50, height: 50)
        
        // Hide keyboard:
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // CODEREVIEW: resignFirstResponder and becomeFirstResponder return bool results which you are ignoring.  What happens if they fail?
        
        // RESEARCH ON RESIGNFIRSTRESPONDER AND FIND A WAY TO SAFELY CALL METHOD
        
        textField.resignFirstResponder()
        if textField == emailAddressEntryTextField {
            passwordCreateEntryTextField.becomeFirstResponder()
        } else if textField == passwordCreateEntryTextField {
            passwordConfirmEntryTextField.becomeFirstResponder()
        }
        return true
    }
    
    // CODEREVIEW: In the four methods below, you are making the same call to UIView.animate(...) four different times with variations only to the x: and width: parameters.  Consider finding a way to refactor this to reduce code repetition.
    
    // NEED TO FIND A WAY TO SHORTEN CODE BELOW:
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let signupButton = sender as! UIButton
        
//        let bounds = signupButton.bounds
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
//            signupButton.bounds = CGRect(x: bounds.origin.x - 5, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
//        }, completion: nil)
    }
    
    @IBAction func signupButtonReleased(_ sender: Any) {
        let signupButton = sender as! UIButton
        
//        let bounds = signupButton.bounds
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
//            signupButton.bounds = CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
//        }, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let loginButton = sender as! UIButton
        
//        let bounds = loginButton.bounds
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
//            loginButton.bounds = CGRect(x: bounds.origin.x - 5, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
//        }, completion: nil)
    }
    
    @IBAction func loginButtonReleased(_ sender: Any) {
        let loginButton = sender as! UIButton
        
//        let bounds = loginButton.bounds
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
//            loginButton.bounds = CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
//        }, completion: nil)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        /*let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me")) { (httpResponse, result) in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
            
            case .failed(let error):
                print("Graph request failed: \(error)")
            }
        }
            connection.start()*/
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil {
                print("Failed to create user with Facebook credentials: \(String(describing: err)).")
                return
            }
            print("Login succeeded: \(String(describing: user))!")
            self.dismiss(animated: true, completion: nil)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("Graph request failed: \(error)")
                return
            }
                print(result)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did log out from Facebook.")
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
            let loginLoadingView = NVActivityIndicatorView(frame: loadingViewFrameRect, type: NVActivityIndicatorType.ballRotate, color: aimApplicationThemeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
            
            guard let email = emailAddressEntryTextField.text, let pwd1 = passwordCreateEntryTextField.text, let pwd2 = passwordConfirmEntryTextField.text else {
                return
            }
            
            if pwd1 != "" && pwd1 == pwd2 {
                moveLoadingView(loadingView: loginLoadingView)
                
                Auth.auth().createUser(withEmail: email, password: pwd1, completion: { (user: User?, error) in
                    if error != nil {
                        self.endLoadingView(movingLoadingView: loginLoadingView)
                        self.emailAddressEntryTextField.shake()
                        let statusBarNotification = AimStandardStatusBarNotification()
                        statusBarNotification.display(withMessage: "The email address entered is in use or badly formatted, please check again.", forDuration: 1.5)
                        
                        print(error as Any)
                        return
                    }
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    // CODEREVIEW: What if the hardcoded URL here changes?  Consider reading it from a plist instead of hardcoding it.
                    let reference = Database.database().reference(fromURL: "https://aim-a3c43.firebaseio.com/")
                    let userReference = reference.child("users").child(uid)
                    let userInfoValues = ["Email" : email, "Password" : pwd1, "Tokens" : 0] as [String : Any]
                    userReference.updateChildValues(userInfoValues, withCompletionBlock: { (err, reference) in
                        if err != nil {
                            self.endLoadingView(movingLoadingView: loginLoadingView)
                            print(err as Any)
                            return
                        }
                        if Auth.auth().currentUser?.uid != nil {
                            self.dismiss(animated: true, completion: nil)
                        }
                        print("User creation success.")
                    })
                    print("Registered new user.")
                })
            } else {
                self.endLoadingView(movingLoadingView: loginLoadingView)
                self.passwordCreateEntryTextField.shake()
                self.passwordConfirmEntryTextField.shake()
                
                let notification = AimStandardStatusBarNotification()
                notification.display(withMessage: "Two passwords do not match or are empty.", forDuration: 1.5)
            }
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        // If the password confirming textfield isn't hidden, hide it
        let loginLoadingView = NVActivityIndicatorView(frame: loadingViewFrameRect, type: NVActivityIndicatorType.ballRotate, color: themeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
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
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    self.endLoadingView(movingLoadingView: loginLoadingView)
                    self.passwordCreateEntryTextField.shake()
                    
                    let statusBarNotification = AimStandardStatusBarNotification()
                    statusBarNotification.display(withMessage: "One of your entries is incorrect. Please check again.", forDuration: 1.5)
                    print(error as Any)
                }
                if Auth.auth().currentUser?.uid != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
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
