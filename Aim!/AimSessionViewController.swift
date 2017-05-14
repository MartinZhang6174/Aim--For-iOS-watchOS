//
//  AimSessionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import UserNotifications

class AimSessionViewController: UIViewController, AimSessionDurationInfoDelegate {

    var timerManager = TimerManager()
    
    let requestIdentifier = "AimLocalNotificationRequest" //identifier is to cancel the notification request
    
    var sessionTitleStringValue = ""
    
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        // Add observers to handle timer label update and completed timer.
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.updateTimerLabel), name: NSNotification.Name(rawValue: TimerManager.notificationSecondTick), object: timerManager)
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.timerComplete), name: NSNotification.Name(rawValue: TimerManager.notificationComplete), object: timerManager)
        
        updateTimerLabel()
        
        // sessionTimerLabel.text = String(secondsElapsed)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionTitleLabel.text = sessionTitleStringValue
    }
    
    // MARK: - AimSessionDurationInfoDelegate
    func getSessionDuration(_ durationInSeconds: TimeInterval) {
        // sessionTitleLabel.text = "\(Int(durationInSeconds / 60))-Minute-Long Session In Progress!"
        timerManager.duration = TimeInterval(durationInSeconds)
        timerManager.startTimer()
    }
    
    func getSessionDurationForSessionWithoutDurationLimits() {
        sessionTimerLabel.text = "'Forever-long' Session In Progress!"
        timerManager.startTimer()
    }
    
    @IBAction func startSessionButtonPressed(_ sender: Any) {
        // aimTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAimSessionTimerLabel), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseSessionButtonClicked(_ sender: Any) {
        // aimTimer.invalidate()
    }
    
    @IBAction func terminateSessionButtonClicked(_ sender: Any) {
        timerManager.stopTimer()
        dismiss(animated: true, completion: nil)
    }
    
    func updateAimSessionTimerLabel() {
        // secondsElapsed += 1
        // sessionTimerLabel.text = String(secondsElapsed)
    }
    
    func updateTimerLabel() {
        let currentTime = timerManager.elapsedTime
        sessionTimerLabel.text = Utility.convertSecondsToTimeString(currentTime)
    }
    
    func timerComplete() {
        dismiss(animated: true, completion: nil)

        print("This is where you need to send the users a NOTIFICATION!!!!!")
        
        let content = UNMutableNotificationContent()
        content.title = "Aim! Session Completed!"
        // content.subtitle = "You have successfully finished your Aim! Session."
        content.body = "Token earned: 237 🏆"
        content.sound = UNNotificationSound.default()
        
//        //To Present image in notification
//        if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
//            let url = URL(fileURLWithPath: path)
//            
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
//                content.attachments = [attachment]
//            } catch {
//                print("attachment not found.")
//            }
//        }
        
        // Deliver the notification in five seconds.
        // let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                print(error?.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AimSessionViewController: UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
