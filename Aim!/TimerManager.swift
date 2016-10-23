//
//  TimerManager.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-16.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

class TimerManager {
    
    // MARK: - Properties
    let TIME_INTERVAL: TimeInterval = 1
    
    var duration: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    
    var aimTimer: Timer?
    
    var isOn: Bool {
        get {
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
        
        if self.elapsedTime == self.duration {
            self.stopTimer()
        }
    }
}
