//
//  AimSessionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import CoreMotion

class AimSessionViewController: UIViewController, AimSessionDurationInfoDelegate {
    
    var sessionTitleStringValue = ""

    var timerManager = TimerManager()
    
    var motionManager = CMMotionManager()
    
    var currentMaxAccX: Double = 0.0
    var currentMaxAccY: Double = 0.0
    var currentMaxAccZ: Double = 0.0
    
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        // Add observers to handle timer label update and completed timer.
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.updateTimerLabel), name: NSNotification.Name(rawValue: TimerManager.notificationSecondTick), object: timerManager)
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionViewController.timerComplete), name: NSNotification.Name(rawValue: TimerManager.notificationComplete), object: timerManager)
        
        updateTimerLabel()
        
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.gyroUpdateInterval = 0.5
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, error: Error?) in
            self.outputAccelerometerData(acceleration: (accelerometerData?.acceleration)!)
            if (error != nil) {
                print("Error: \(error)")
            }
        }
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
        // Do this when timer completes its full duration.
    }
    
    func outputAccelerometerData(acceleration: CMAcceleration) {
        var xDirectionAccel = acceleration.x
        var yDirectionAccel = acceleration.y
        var zDirectionAccel = acceleration.z
        
//        || abs(yDirectionAccel)>0.1 || abs(zDirectionAccel)>0.1
        
        if abs(xDirectionAccel)>0.5 || abs(yDirectionAccel)>0.5 {
            print("BIG MOVE BRO!??")
            
            // Warn the user to put down the phone:
            
        }
//        print("<<<<<<<<<<<<<<<<<<<<<<<<<<< AccelerationX: \(acceleration.x).2fg")
//        print("<<<<<<<<<<<<<<<<<<<<<<<<<<< AccelerationY: \(acceleration.y).2fg")
//        print("<<<<<<<<<<<<<<<<<<<<<<<<<<< AccelerationZ: \(acceleration.z).2fg")
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
