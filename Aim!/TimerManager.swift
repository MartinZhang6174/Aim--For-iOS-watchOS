//
//  TimerManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2016-10-16.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

class TimerManager {
    
    // MARK: - Properties
    static let notificationSecondTick = "TimerNotificationSecondTick"
    static let notificationComplete = "TimerNotificationComplete"
    
    // MARK: - Properties
    // CODEREVIEW: Keep your variable names consistent.  In all your other files, you use camelCase for "let" members.  In this one time you use ALL_UPPERCASE style.  Pick one and don't change.
    let TIME_INTERVAL: TimeInterval = 1
    
    var duration: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    
    var aimTimer: Timer?
    
    var isOn: Bool {
        get {
            // CODEREVIEW: You can write if-statements like these in a single line.
            // e.g. return (aimTimer != nil)
            if aimTimer != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: - Timer Functions
    func startTimer() {
        if !isOn {
            aimTimer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL, target: self, selector: #selector(self.secondTick), userInfo: nil, repeats: true)
            
            print("Timer started.")
        }
    }
    
    func stopTimer() {
        if isOn {
            aimTimer?.invalidate()
            aimTimer = nil
            
            print("Timer stopped.")
        }
    }
    // MARK: - General Functions
    @objc func secondTick() {
        elapsedTime += 1
        
        print("\(self.elapsedTime) second.")
        NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationSecondTick), object: self)

        
        if self.elapsedTime == self.duration {
            self.stopTimer()
            NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationComplete), object: self)
        }
    }
}
