//
//  AimCurrentUserRemindersTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-02.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimCurrentUserRemindersTableViewController: UITableViewController {
    
    @IBOutlet weak var mondaysReminderLabel: UILabel!
    @IBOutlet weak var tuesdaysReminderLabel: UILabel!
    @IBOutlet weak var wednesdaysReminderLabel: UILabel!
    @IBOutlet weak var thursdaysReminderLabel: UILabel!
    @IBOutlet weak var fridaysReminderLabel: UILabel!
    @IBOutlet weak var saturdaysReminderLabel: UILabel!
    @IBOutlet weak var sundaysReminderLabel: UILabel!
    
    lazy var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mondaysReminderInfo = defaults.string(forKey: "AimUserMondaysReminderInfo") {
            mondaysReminderLabel.text = "Mondays - \(mondaysReminderInfo)"
        }
        
        if let tuesdaysReminderInfo = defaults.string(forKey: "AimUserTuesdaysReminderInfo") {
            tuesdaysReminderLabel.text = "Tuesdays - \(tuesdaysReminderInfo)"
        }
        
        if let wednesdaysReminderInfo = defaults.string(forKey: "AimUserWednesdaysReminderInfo") {
            wednesdaysReminderLabel.text = "Wednesdays - \(wednesdaysReminderInfo)"
        }
        
        if let thursdaysReminderInfo = defaults.string(forKey: "AimUserThursdaysReminderInfo") {
            thursdaysReminderLabel.text = "Thursdays - \(thursdaysReminderInfo)"
        }
        
        if let fridaysReminderInfo = defaults.string(forKey: "AimUserFridaysReminderInfo") {
            fridaysReminderLabel.text = "Fridays - \(fridaysReminderInfo)"
        }
        
        if let saturdaysReminderInfo = defaults.string(forKey: "AimUserSaturdaysReminderInfo") {
            saturdaysReminderLabel.text = "Saturdays - \(saturdaysReminderInfo)"
        }
        
        if let sundaysReminderInfo = defaults.string(forKey: "AimUserSundaysReminderInfo") {
            sundaysReminderLabel.text = "Sundays - \(sundaysReminderInfo)"
        }
    }
    @IBAction func clearAllRemindersButtonClicked(_ sender: Any) {
        defaults.removeObject(forKey: "AimUserMondaysReminderInfo")
        defaults.removeObject(forKey: "AimUserTuesdaysReminderInfo")
        defaults.removeObject(forKey: "AimUserWednesdaysReminderInfo")
        defaults.removeObject(forKey: "AimUserThursdaysReminderInfo")
        defaults.removeObject(forKey: "AimUserFridaysReminderInfo")
        defaults.removeObject(forKey: "AimUserSaturdaysReminderInfo")
        defaults.removeObject(forKey: "AimUserSundaysReminderInfo")
        
        dismiss(animated: true, completion: nil)
    }
}
