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
    static let notificationOneMinutePoint = "TimerNotificationOneMinutePoint"
    
    // MARK: - Properties
    let timeInterval: TimeInterval = 0.005
    
    var duration: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    
    var aimTimer: Timer?
    var minuteTimer: Timer?
    
    var isOn: Bool {
        get {
            return (aimTimer != nil)
        }
    }
    
    // MARK: - Timer Functions
    func startTimer() {
        if !isOn {
            aimTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.secondTick), userInfo: nil, repeats: true)
            
            minuteTimer = Timer.scheduledTimer(timeInterval: timeInterval*60, target: self, selector: #selector(self.minutePoint), userInfo: nil, repeats: true)
            print("Timer started.")
        }
    }
    
    func stopTimer() {
        if isOn {
            aimTimer?.invalidate()
            aimTimer = nil
        }
    }
    
    // MARK: - General Functions
    @objc private func secondTick() {
        elapsedTime += 1
        
        // print("\(self.elapsedTime) second.")
        NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationSecondTick), object: self)
        
        
        if self.elapsedTime == self.duration {
            self.stopTimer()
            NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationComplete), object: self)
        }
    }
    
    @objc private func minutePoint() {
        NotificationCenter.default.post(name: Notification.Name(TimerManager.notificationOneMinutePoint), object: self)
    }
}
