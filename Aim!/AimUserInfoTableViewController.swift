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
            } else {
                performSegue(withIdentifier: "UserInfoVCtoEmailAddressChangeVCSegue", sender: self)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
