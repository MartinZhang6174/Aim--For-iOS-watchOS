//
//  SessionVC.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-24.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

class SessionVC: UIViewController, DurationDelegate {
    
    // MARK: - Properties
    var timerManager = TimerManager()
    
    @IBOutlet weak var timerLabel: UILabel!
    
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
