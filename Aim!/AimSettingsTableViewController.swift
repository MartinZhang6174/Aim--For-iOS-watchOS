//
//  AimSettingsTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-08.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity

class AimSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var loginCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var statusBarStyleSwitch: UISwitch!
    
    lazy var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar bg colour(tintcolor is what apple calls it)
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        self.navigationController?.navigationBar.tintColor = aimApplicationThemeOrangeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBarLightened = defaults.bool(forKey: "LightStatusBarStyle")
//        let themeColorDarkened = defaults.bool(forKey: "DarkenedThemeColor")
        let socialSharingEnabled = defaults.bool(forKey: "EnabledSocialMediaSharing")
        /*if let forceTouchValue = defaults.float(forKey: "AimSessionForceRequiredToTouch") as? Float {
            if forceTouchValue == 0.8 {
                forceTouchSelectionSwitch.setOn(true, animated: true)
            } else {
                forceTouchSelectionSwitch.setOn(false, animated: true)
            }
        }*/
        
        statusBarStyleSwitch.setOn(statusBarLightened, animated: true)
//        themeColorSwitch.setOn(themeColorDarkened, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
        
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
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        /*WCSession.default().sendMessage(["UserAuthState": false], replyHandler: nil, errorHandler: { (err) in
            print("Could not establish communications to WatchKit app: \(err)")
        })*/
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let statusBarLightened = statusBarStyleSwitch.isOn
//        let themeColorDarkened = themeColorSwitch.isOn
//        let socialSharingEnabled = socialMediaSharingSwitch.isOn
        
        defaults.set(statusBarLightened, forKey: "LightStatusBarStyle")
//        defaults.set(themeColorDarkened, forKey: "DarkenedThemeColor")
//        defaults.set(socialSharingEnabled, forKey: "EnabledSocialMediaSharing")
        
        /*if forceTouchSelectionSwitch.isOn == true {
            defaults.set(0.8, forKey: "AimSessionForceRequiredToTouch")
        } else {
            defaults.set(0.0, forKey: "AimSessionForceRequiredToTouch")
        }*/
        performSettingChanges(with: statusBarLightened)
        let notification = AimStandardStatusBarNotification()
        notification.display(withMessage: "Settings saved and performed!", forDuration: 1.5)
    }
    
    private func performSettingChanges(with lightStatusBarStyle: Bool) {
        if lightStatusBarStyle == true {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        dismiss(animated: true) { 
            print("Settings saving completed.")
        }
    }
    
    @IBAction func syncDataToWatchAppButtonClicked(_ sender: Any) {
        // Dismiss the view to go to MainVC; there has code in viewDidAppear to send sessions over to watch app
        
        if Auth.auth().currentUser?.uid != nil {
            let statusBarNotification = AimStandardStatusBarNotification()
            statusBarNotification.display(withMessage: "Sessions on their way to your watch!", forDuration: 1.5)
            
            dismiss(animated: true, completion: nil)
        } else {
            let statusBarNotification = AimStandardStatusBarNotification()
            statusBarNotification.display(withMessage: "Please login to use the watch app.", forDuration: 1.5)
            
            WCSession.default().sendMessage(["UserAuthState": false], replyHandler: nil, errorHandler: { (err) in
                print("Could not establish communications to WatchKit app: \(err)")
            })
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
