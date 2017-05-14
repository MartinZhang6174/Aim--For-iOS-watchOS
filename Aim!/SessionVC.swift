//
//  SessionVC.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-24.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

// CODEREVIEW: This class has an inconsistent name.  Your other classes are named AimXxxx.

class SessionVC: UIViewController, DurationDelegate {
    
    // MARK: - Properties
    var timerManager = TimerManager()
    
    @IBOutlet weak var timerLabel: UILabel!
  
  
    // CODEREVIEW: Remove code that does not do anything or only calls super.  You haven't introduced any new functionality here, so it should be cleaned up.
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Duration Delegate
    func beginCustomSession(durationInSeconds: TimeInterval) {
        timerManager.duration = durationInSeconds
        timerManager.startTimer()
    }
    
    func beginEndlessSession() {
        timerManager.startTimer()
    }
}
