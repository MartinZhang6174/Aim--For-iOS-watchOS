//
//  AimUserInfoTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class AimUserInfoTableViewController: UITableViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        if let username = Auth.auth().currentUser?.displayName {
            usernameLabel.text = username
        } else {
            usernameLabel.text = "N/A"
        }
        
        if let userEmail = Auth.auth().currentUser?.email {
            userEmailLabel.text = userEmail
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            print("Gotcha")
            if FBSDKAccessToken.current() != nil {
                performSegue(withIdentifier: "UserInfoFailedToChangeEmailSegue", sender: self)
            }
            
            if GIDSignIn.sharedInstance().hasAuthInKeychain() == true {
                performSegue(withIdentifier: "UserInfoFailedToChangeEmailSegue", sender: self)
            }
            
            if FBSDKAccessToken.current() == nil && GIDSignIn.sharedInstance().hasAuthInKeychain() == false {
                performSegue(withIdentifier: "UserInfoVCtoEmailAddressChangeVCSegue", sender: self)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserInfoFailedToChangeEmailSegue" {
            if let destVC = segue.destination as? AimEmailChangeFailureViewController {
                if GIDSignIn.sharedInstance().hasAuthInKeychain() == true {
                    destVC.displayText = "We're sorry. We do not reset the email address for an account with provider(Google) Login credentials."
                }
                
                if FBSDKAccessToken.current() != nil {
                    destVC.displayText = "We're sorry. We do not reset the email address for an account with provider(Facebook) Login credentials."
                }
            }
        }
    }
}
