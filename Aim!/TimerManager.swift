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
    let timeInterval: TimeInterval = 0.5
    
    var duration: TimeInterval = 0
    var previousElapsedTime: TimeInterval = 0
    var startTime: Date?
    var lastMinuteNotificationSentAt: TimeInterval = 0
    
    weak var aimTimer: Timer?
    var totalElapsedTime: TimeInterval {
        if let startedAt = self.startTime {
            return self.previousElapsedTime + abs(startedAt.timeIntervalSinceNow)
        }
        return self.previousElapsedTime
    }
    
    var isOn = false
    
    init() {
        #if os(iOS)
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        #endif
    }
    
    
    @objc func didEnterBackground() {
        self.pauseTimer()
    }
    
    @objc func willEnterForeground() {
        if self.isOn { self.startTimer() }
    }
    // MARK: - Timer Functions
    
    // MARK: - Timer Functions
    func startTimer() {
        if self.startTime != nil { return }
        
        self.isOn = true
        self.startTime = Date()
        aimTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.secondTick), userInfo: nil, repeats: true)
        
        print("Timer started.")
    }
    
    func pauseTimer() {
        self.previousElapsedTime = self.totalElapsedTime
        self.startTime = nil
        self.aimTimer?.invalidate()
    }
  
    func resetTimer() {
        self.pauseTimer()
        self.previousElapsedTime = 0
    }
    
    func stopTimer() {
        self.isOn = false
        self.pauseTimer()
    }
    
    // MARK: - General Functions
    @objc private func secondTick() {
        // print("\(self.elapsedTime) second.")
        NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationSecondTick), object: self)
        
        let elapsed = self.totalElapsedTime
        if elapsed >= (self.lastMinuteNotificationSentAt + 60) {
            self.lastMinuteNotificationSentAt = elapsed
            NotificationCenter.default.post(name: Notification.Name(TimerManager.notificationOneMinutePoint), object: self)
        }
        
        if elapsed >= self.duration {
            self.stopTimer()
            NotificationCenter.default.post(name: Notification.Name(rawValue: TimerManager.notificationComplete), object: self)
        }
    }
}
