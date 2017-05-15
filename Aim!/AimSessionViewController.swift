//
//  AimSessionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSessionViewController: UIViewController, AimSessionDurationInfoDelegate {

    var timerManager = TimerManager()
    
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
        dismiss(animated: true, completion: nil)
    }
    
    func updateAimSessionTimerLabel() {
        // secondsElapsed += 1
        // sessionTimerLabel.text = String(secondsElapsed)
    }
    
    func updateTimerLabel() {
        let currentTime = timerManager.elapsedTime
        sessionTimerLabel.text = Utility.timeString(fromSeconds: currentTime)
    }
    
    func timerComplete() {
        // Do this when timer completes its full duration.
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
