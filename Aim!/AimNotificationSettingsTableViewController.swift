//
//  AimNotificationSettingsTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-19.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import BEMCheckBox
import Foundation
import UserNotifications

class AimNotificationSettingsTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var monButton: UIButton!
    @IBOutlet weak var tueButton: UIButton!
    @IBOutlet weak var wedButton: UIButton!
    @IBOutlet weak var thuButton: UIButton!
    @IBOutlet weak var friButton: UIButton!
    @IBOutlet weak var satButton: UIButton!
    @IBOutlet weak var sunButton: UIButton!
    
    @IBOutlet weak var monCheckBox: BEMCheckBox!
    @IBOutlet weak var tueCheckBox: BEMCheckBox!
    @IBOutlet weak var wedCheckBox: BEMCheckBox!
    @IBOutlet weak var thuCheckBox: BEMCheckBox!
    @IBOutlet weak var friCheckBox: BEMCheckBox!
    @IBOutlet weak var satCheckBox: BEMCheckBox!
    @IBOutlet weak var sunCheckBox: BEMCheckBox!
    
    @IBOutlet weak var reminderTimePicker: UIDatePicker!
    
    lazy var defaults = UserDefaults.standard
    
    fileprivate let mondaysRequestIdentifier = "AimMondaysAppUseReminderLocalNotification"
    fileprivate let tuesdaysRequestIdentifier = "AimTuesdaysAppUseReminderLocalNotification"
    fileprivate let wednesdaysRequestIdentifier = "AimWednesdaysAppUseReminderLocalNotification"
    fileprivate let thursdaysRequestIdentifier = "AimThursdaysAppUseReminderLocalNotification"
    fileprivate let fridaysRequestIdentifier = "AimFridaysAppUseReminderLocalNotification"
    fileprivate let saturdaysRequestIdentifier = "AimSaturdaysAppUseReminderLocalNotification"
    fileprivate let sundaysRequestIdentifier = "AimSundaysAppUseReminderLocalNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = aimApplicationThemePurpleColor
        
        monCheckBox.onAnimationType = BEMAnimationType.fill
        monCheckBox.offAnimationType = BEMAnimationType.fill
        tueCheckBox.onAnimationType = BEMAnimationType.fill
        tueCheckBox.offAnimationType = BEMAnimationType.fill
        wedCheckBox.onAnimationType = BEMAnimationType.fill
        wedCheckBox.offAnimationType = BEMAnimationType.fill
        thuCheckBox.onAnimationType = BEMAnimationType.fill
        thuCheckBox.offAnimationType = BEMAnimationType.fill
        friCheckBox.onAnimationType = BEMAnimationType.fill
        friCheckBox.offAnimationType = BEMAnimationType.fill
        satCheckBox.onAnimationType = BEMAnimationType.fill
        satCheckBox.offAnimationType = BEMAnimationType.fill
        sunCheckBox.onAnimationType = BEMAnimationType.fill
        sunCheckBox.offAnimationType = BEMAnimationType.fill
        
        reminderTimePicker.setValue(aimApplicationThemeOrangeColor, forKey: "textColor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.string(forKey: "AimUserMondaysReminderInfo") == nil {
            monCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserTuesdaysReminderInfo") == nil {
            tueCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserWednesdaysReminderInfo") == nil {
            wedCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserThursdaysReminderInfo") == nil {
            thuCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserFridaysReminderInfo") == nil {
            friCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserSaturdaysReminderInfo") == nil {
            satCheckBox.setOn(true, animated: true)
        }
        if defaults.string(forKey: "AimUserSundaysReminderInfo") == nil {
            sunCheckBox.setOn(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        if reminderSwitch.isOn {
            monCheckBox.tintColor = aimApplicationThemeOrangeColor
            tueCheckBox.tintColor = aimApplicationThemeOrangeColor
            thuCheckBox.tintColor = aimApplicationThemeOrangeColor
            wedCheckBox.tintColor = aimApplicationThemeOrangeColor
            thuCheckBox.tintColor = aimApplicationThemeOrangeColor
            friCheckBox.tintColor = aimApplicationThemeOrangeColor
            satCheckBox.tintColor = aimApplicationThemeOrangeColor
            sunCheckBox.tintColor = aimApplicationThemeOrangeColor
            
            monCheckBox.isEnabled = true
            tueCheckBox.isEnabled = true
            wedCheckBox.isEnabled = true
            thuCheckBox.isEnabled = true
            friCheckBox.isEnabled = true
            satCheckBox.isEnabled = true
            sunCheckBox.isEnabled = true
            
            reminderTimePicker.setValue(aimApplicationThemeOrangeColor, forKey: "textColor")
            reminderTimePicker.isEnabled = true
            
        } else {
            monCheckBox.setOn(false, animated: false)
            tueCheckBox.setOn(false, animated: false)
            thuCheckBox.setOn(false, animated: false)
            wedCheckBox.setOn(false, animated: false)
            thuCheckBox.setOn(false, animated: false)
            friCheckBox.setOn(false, animated: false)
            satCheckBox.setOn(false, animated: false)
            sunCheckBox.setOn(false, animated: false)
            
            monCheckBox.tintColor = UIColor.lightGray
            tueCheckBox.tintColor = UIColor.lightGray
            thuCheckBox.tintColor = UIColor.lightGray
            wedCheckBox.tintColor = UIColor.lightGray
            thuCheckBox.tintColor = UIColor.lightGray
            friCheckBox.tintColor = UIColor.lightGray
            satCheckBox.tintColor = UIColor.lightGray
            sunCheckBox.tintColor = UIColor.lightGray
            
            monCheckBox.isEnabled = false
            tueCheckBox.isEnabled = false
            wedCheckBox.isEnabled = false
            thuCheckBox.isEnabled = false
            friCheckBox.isEnabled = false
            satCheckBox.isEnabled = false
            sunCheckBox.isEnabled = false
            
            monButton.isEnabled = false
            tueButton.isEnabled = false
            wedButton.isEnabled = false
            thuButton.isEnabled = false
            friButton.isEnabled = false
            satButton.isEnabled = false
            sunButton.isEnabled = false
            
            reminderTimePicker.setValue(UIColor.lightGray, forKey: "textColor")
            reminderTimePicker.isEnabled = false
        }
    }
    
    @IBAction func mondayClicked(_ sender: Any) {
        print("mondayClicked")
        if monCheckBox.on {
            monCheckBox.setOn(false, animated: true)
        } else {
            monCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func tuesdayClicked(_ sender: Any) {
        print("tuesdayClicked")
        if tueCheckBox.on {
            tueCheckBox.setOn(false, animated: true)
        } else {
            tueCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func wednesdayClicked(_ sender: Any) {
        print("wednesdayClicked")
        if wedCheckBox.on {
            wedCheckBox.setOn(false, animated: true)
        } else {
            wedCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func thursdayClicked(_ sender: Any) {
        print("thursdayClicked")
        if thuCheckBox.on {
            thuCheckBox.setOn(false, animated: true)
        } else {
            thuCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func fridayClicked(_ sender: Any) {
        print("fridayClicked")
        if friCheckBox.on {
            friCheckBox.setOn(false, animated: true)
        } else {
            friCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func saturdayClicked(_ sender: Any) {
        print("saturdayClicked")
        if satCheckBox.on {
            satCheckBox.setOn(false, animated: true)
        } else {
            satCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func sundayClicked(_ sender: Any) {
        print("sundayClicked")
        if sunCheckBox.on {
            sunCheckBox.setOn(false, animated: true)
        } else {
            sunCheckBox.setOn(true, animated: true)
        }
    }
    
    @IBAction func monBoxClicked(_ sender: Any) {
        if monCheckBox.on {
            monCheckBox.setOn(true, animated: true)
        } else {
            monCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func tueBoxClicked(_ sender: Any) {
        if tueCheckBox.on {
            tueCheckBox.setOn(true, animated: true)
        } else {
            tueCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func wedBoxClicked(_ sender: Any) {
        if wedCheckBox.on {
            wedCheckBox.setOn(true, animated: true)
        } else {
            wedCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func thuBoxClicked(_ sender: Any) {
        if thuCheckBox.on {
            thuCheckBox.setOn(true, animated: true)
        } else {
            thuCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func friBoxClicked(_ sender: Any) {
        if friCheckBox.on {
            friCheckBox.setOn(true, animated: true)
        } else {
            friCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func satBoxClicked(_ sender: Any) {
        if satCheckBox.on {
            satCheckBox.setOn(true, animated: true)
        } else {
            satCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func sunBoxClicked(_ sender: Any) {
        if sunCheckBox.on {
            sunCheckBox.setOn(true, animated: true)
        } else {
            sunCheckBox.setOn(false, animated: true)
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSettingsButtonClicked(_ sender: Any) {
        // Save reminder settings
        if reminderSwitch.isOn {
            let pickedDate = reminderTimePicker.date
            let calendar = Calendar.current
            let pickedDateComponents = calendar.dateComponents([.hour, .minute], from: pickedDate)
            let pickedHour = pickedDateComponents.hour!
            let pickedMinute = pickedDateComponents.minute!
            print("\(pickedHour), \(pickedMinute)")
            let pickedReminderHourString = String(format: "%02d", pickedDateComponents.hour!)
            let pickedReminderMinuteString = String(format: "%02d", pickedDateComponents.minute!)
            let reminderTimeString = " \(pickedReminderHourString):\(pickedReminderMinuteString) "

            if monCheckBox.on {
                var date = DateComponents()
                date.weekday = 2
                date.hour = pickedHour
                date.minute = pickedMinute
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: mondaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserMondaysReminderInfo")
            }
            if tueCheckBox.on {
                var date = DateComponents()
                date.weekday = 3
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: tuesdaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserTuesdaysReminderInfo")
            }
            if wedCheckBox.on {
                var date = DateComponents()
                date.weekday = 4
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: wednesdaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserWednesdaysReminderInfo")
            }
            if thuCheckBox.on {
                var date = DateComponents()
                date.weekday = 5
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: thursdaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserThursdaysReminderInfo")
            }
            if friCheckBox.on {
                var date = DateComponents()
                date.weekday = 6
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: fridaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserFridaysReminderInfo")
            }
            if satCheckBox.on {
                var date = DateComponents()
                date.weekday = 7
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: saturdaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserSaturdaysReminderInfo")
            }
            if sunCheckBox.on {
                var date = DateComponents()
                date.weekday = 1
                //                print("Set reminder at \(pickedDateComponents.hour!):\(pickedDateComponents.minute!)")
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: sundaysRequestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
                saveRemindersToUserDefaults(with: reminderTimeString, and: "AimUserSundaysReminderInfo")
            }
        } else {
            let userNotificationCentre = UNUserNotificationCenter.current()
            userNotificationCentre.removePendingNotificationRequests(withIdentifiers: [mondaysRequestIdentifier, tuesdaysRequestIdentifier, wednesdaysRequestIdentifier, thursdaysRequestIdentifier, fridaysRequestIdentifier, saturdaysRequestIdentifier, sundaysRequestIdentifier])
            print("Cancelled all pending local notification requests.")
            
            defaults.removeObject(forKey: "AimUserMondaysReminderInfo")
            defaults.removeObject(forKey: "AimUserTuesdaysReminderInfo")
            defaults.removeObject(forKey: "AimUserWednesdaysReminderInfo")
            defaults.removeObject(forKey: "AimUserThursdaysReminderInfo")
            defaults.removeObject(forKey: "AimUserFridaysReminderInfo")
            defaults.removeObject(forKey: "AimUserSaturdaysReminderInfo")
            defaults.removeObject(forKey: "AimUserSundaysReminderInfo")
        }
//        dismiss(animated: true, completion: nil)
    }
    
    
    func saveRemindersToUserDefaults(with timeString: String, and key: String) {
        if defaults.string(forKey: key) != nil {
            defaults.removeObject(forKey: key)
            defaults.set(timeString, forKey: key)
        } else {
            defaults.set(timeString, forKey: key)
        }
    }
    
    // MARK: User Notification Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //May either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == mondaysRequestIdentifier || notification.request.identifier == tuesdaysRequestIdentifier || notification.request.identifier == wednesdaysRequestIdentifier || notification.request.identifier ==  thursdaysRequestIdentifier || notification.request.identifier == fridaysRequestIdentifier || notification.request.identifier ==  saturdaysRequestIdentifier || notification.request.identifier == sundaysRequestIdentifier {
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
