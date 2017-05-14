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
  
    // CODEREVIEW: Remove commented code.

//    var seconds = 60
    // var aimTimer = Timer()
    // var secondsElapsed = 0
    
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
      
        // CODEREVIEW: Remove commented code.

        // sessionTimerLabel.text = String(secondsElapsed)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionTitleLabel.text = sessionTitleStringValue
    }
    
    // MARK: - AimSessionDurationInfoDelegate
    func getSessionDuration(_ durationInSeconds: TimeInterval) {
        // CODEREVIEW: Remove commented code.

        // sessionTitleLabel.text = "\(Int(durationInSeconds / 60))-Minute-Long Session In Progress!"
        timerManager.duration = TimeInterval(durationInSeconds)
        timerManager.startTimer()
    }
    
    func getSessionDurationForSessionWithoutDurationLimits() {
        sessionTimerLabel.text = "'Forever-long' Session In Progress!"
        timerManager.startTimer()
    }
  
    // CODEREVIEW: Remove commented code.  Consider removing the IBActions below altogether.  Keeping the code "clean" means this: Everything that is needed is included in the code, Everything that is NOT NEEDED is not in the code.

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
