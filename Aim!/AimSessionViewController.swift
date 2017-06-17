//
//  AimSessionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import UserNotifications
import RealmSwift
import Firebase

class AimSessionViewController: UIViewController, AimSessionDurationInfoDelegate {
    
    var sessionTitleStringValue = ""
    
    var timerManager = TimerManager()
    
    var firebaseTokenContainer: Float = 0
    var tokenContainer: Float = 0
    
    var motionManager = CMMotionManager()
    // Initializing a LocationManager to bypass Apple policies on categories of apps that are allowed to update accelerometer data in the background for more than 10 mins:
    var locationManager = CLLocationManager()
    
    var currentMaxAccX: Double = 0.0
    var currentMaxAccY: Double = 0.0
    var currentMaxAccZ: Double = 0.0
    
    let requestIdentifier = "AimLocalNotificationRequest" //identifier is to cancel the notification request
    
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    @IBOutlet weak var sessionTokensLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        // Add observers to handle timer label update and completed timer.
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.updateTimerLabel), name: NSNotification.Name(rawValue: TimerManager.notificationSecondTick), object: timerManager)
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.timerComplete), name: NSNotification.Name(rawValue: TimerManager.notificationComplete), object: timerManager)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.handleTokenIncrements), name: NSNotification.Name(rawValue: TimerManager.notificationOneMinutePoint), object: timerManager)
        
        updateTimerLabel()
        
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.gyroUpdateInterval = 0.5
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, error: Error?) in
            self.outputAccelerometerData(acceleration: (accelerometerData?.acceleration)!)
            if (error != nil) {
                print("Error: \(String(describing: error))")
                return
            }
        }
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionTitleLabel.text = sessionTitleStringValue
    }
    
    // MARK: - AimSessionDurationInfoDelegate
    func getSessionDuration(_ durationInSeconds: TimeInterval) {
        timerManager.duration = TimeInterval(durationInSeconds)
        timerManager.startTimer()
    }
    
    func getSessionDurationForSessionWithoutDurationLimits() {
        sessionTimerLabel.text = "'Forever-long' Session In Progress!"
        timerManager.startTimer()
    }
    
    @IBAction func terminateSessionButtonClicked(_ sender: Any) {
        timerManager.stopTimer()
        motionManager.stopAccelerometerUpdates()
        locationManager.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }
    
    func updateTimerLabel() {
        let currentTime = timerManager.elapsedTime
        sessionTimerLabel.text = Utility.timeString(fromSeconds: currentTime)
    }
    
    func handleTokenIncrements() {
        tokenContainer += AimTokenConversionManager.sharedInstance.currentTokenFactor()
        
        let roundedTokens = Int(tokenContainer.rounded())
        sessionTokensLabel.text = "\(roundedTokens)"
    }
    
    func timerComplete() {
        dismiss(animated: true, completion: nil)
        
        print("This is where you need to send the users a NOTIFICATION!!!!!")
        
        let content = UNMutableNotificationContent()
        content.title = "Aim! Session Completed!"
        content.body = "Token earned: \(tokenContainer.rounded()) 🏆"
        content.sound = UNNotificationSound.default()
        
        let realm = try! Realm()
        do {
            let user = try realm.object(ofType: AimUser.self, forPrimaryKey: Auth.auth().currentUser?.email)
            try realm.write {
                user?.tokenPool += tokenContainer
                realm.add(user!, update: true)
            }
        } catch let error {
            print(error)
        }
        
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                print(error?.localizedDescription as Any)
                return
            }
        }
        
        if Auth.auth().currentUser?.uid != nil {
            syncUserAndSessionInfo(with: tokenContainer)
        }
    }
    
    func syncUserAndSessionInfo(with tokens: Float) {
        let fireRef = Database.database().reference()
        let userIDPath = Auth.auth().currentUser?.uid as String! // Force unwrapping uid because this method is only called within a block where the app is sure about the user's login status.
        fireRef.child("users").child(userIDPath!).child("Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tokensOnCloud = snapshot.value as? Float {
                // If user has tokens on cloud, add the amount he just gained
                self.firebaseTokenContainer = tokensOnCloud + self.tokenContainer
            }
            // Create new field "Tokens" if this is his first session
            fireRef.child("users").child(userIDPath!).child("Tokens").setValue(self.tokenContainer)
        })
    }
    
    func outputAccelerometerData(acceleration: CMAcceleration) {
        let xDirectionAccel = acceleration.x
        let yDirectionAccel = acceleration.y
        // let zDirectionAccel = acceleration.z
        
        if abs(xDirectionAccel)>0.5 || abs(yDirectionAccel)>0.5 {
            print("BIG MOVE BRO!??")
            
            // Warn the user to put down the phone here:
            
        }
    }
}

extension AimSessionViewController: UNUserNotificationCenterDelegate{
    
    
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
