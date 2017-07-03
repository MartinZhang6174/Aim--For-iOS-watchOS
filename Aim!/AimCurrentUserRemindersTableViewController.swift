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
        let alert = UIAlertController(title: "Alert", message: "Are you sure that you want to remove all existing reminders? Reminders that have been removed cannot be restored.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
            self.defaults.removeObject(forKey: "AimUserMondaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserTuesdaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserWednesdaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserThursdaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserFridaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserSaturdaysReminderInfo")
            self.defaults.removeObject(forKey: "AimUserSundaysReminderInfo")
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            return
        }))
        present(alert, animated: true, completion: nil)
    }
}
