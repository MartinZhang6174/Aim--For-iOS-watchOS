//
//  TimerUtility.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-11.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

class Utility {
    
    class func convertSecondsToTimeString(_ seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds)
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60 ) % 60
        let seconds = totalSeconds % 60
        
        var hoursString = ""
        if hours > 0 {
            hoursString = "\(hours):"
        }
        
        var minutesString = ""
        if minutes < 10 {
            minutesString = "0\(minutes):"
        } else {
            minutesString = "\(minutes):"
        }
        
        var secondsString = ""
        if seconds < 10 {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        return hoursString + minutesString + secondsString
    }
}
