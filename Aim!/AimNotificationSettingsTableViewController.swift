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
    
    fileprivate let requestIdentifier = "AimAppUseReminderLocalNotification"
    
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
            var calendar = Calendar.current
            let pickedDateComponents = calendar.dateComponents([.hour, .minute], from: pickedDate)
            print("\(pickedDateComponents.hour), \(pickedDateComponents.minute)")
            if monCheckBox.on {
                var date = DateComponents()
                date.weekday = 2
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
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
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
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
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
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
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
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
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
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
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
            }
            if sunCheckBox.on {
                var date = DateComponents()
                date.weekday = 1
                date.hour = pickedDateComponents.hour!
                date.minute = pickedDateComponents.minute!
                
                let content = UNMutableNotificationContent()
                content.title = "Time to use Aim!"
                content.body = "Aim! Boosts Your Productivity."
                content.sound = UNNotificationSound.default()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: "AimAppUseReminderLocalNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
            }
        } else {
            let userNotificationCentre = UNUserNotificationCenter.current()
            userNotificationCentre.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
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
        if notification.request.identifier == requestIdentifier{
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
