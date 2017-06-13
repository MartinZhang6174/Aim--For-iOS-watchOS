//
//  AimSettingsTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-08.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var loginCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar bg colour(tintcolor is what apple calls it)
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        self.navigationController?.navigationBar.tintColor = aimApplicationThemeOrangeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        if Auth.auth().currentUser?.uid != nil {
            loginButton.isEnabled = false
            logoutButton.isEnabled = true
        } else {
            loginButton.isEnabled = true
            logoutButton.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsToLoginVCSegue", sender: self)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
