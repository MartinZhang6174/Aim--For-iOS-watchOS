//
//  AimSessionInterfaceController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-27.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class AimSessionInterfaceController: WKInterfaceController {
    
    @IBOutlet var sessionTitleLabel: WKInterfaceLabel!
    @IBOutlet var sessionTokensLabel: WKInterfaceLabel!
    @IBOutlet var sessionTimerLabel: WKInterfaceLabel!
    
    let realm = try! Realm()
    var session: AimSessionLite!
    var user: AimUser?
    var timerManager = TimerManager()
    var sessionTimeInterval: TimeInterval = 1.0
    var sessionTokenTimer: Timer?
    var sessionTokens: Float = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //        let currentUserEmail =
        //        realm.object(ofType: AimUser.self, forPrimaryKey: "")
        
        timerManager.duration = sessionTimeInterval*60*25
        timerManager.startTimer()
        
        // Add observers to handle timer label update and completed timer.
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionInterfaceController.updateTimerLabel), name: NSNotification.Name(rawValue: TimerManager.notificationSecondTick), object: timerManager)
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionInterfaceController.handleTimerCompletion), name: NSNotification.Name(rawValue: TimerManager.notificationComplete), object: timerManager)
        NotificationCenter.default.addObserver(self, selector: #selector(AimSessionInterfaceController.handleTokenIncrements), name: NSNotification.Name(rawValue: TimerManager.notificationOneMinutePoint), object: timerManager)
        
        sessionTokenTimer = Timer.scheduledTimer(timeInterval: sessionTimeInterval*60, target: self, selector: #selector(handleTokenIncrements), userInfo: nil, repeats: true)
        
        // Configure interface objects here.
        if let context = context as? AimSessionLite {
            session = context
            
            setTitle(session.title)
            sessionTitleLabel.setText(session.title)
        }
    }
    
    @objc private func handleTimerCompletion() {
        sessionTokenTimer?.invalidate()
        
        // Saving to realm
        if let userInRealm = realm.objects(AimUserLite.self).first {
            do {
                try! realm.write {
                    userInRealm.tokens += sessionTokens
                    realm.add(userInRealm, update: true)
                }
            } catch let error {
                print("Error saving tokens onto disk: \(error)")
            }
        }
        self.dismiss()
    }
    
    @objc private func updateTimerLabel() {
        let currentTime = timerManager.elapsedTime
        let timerText = Utility.timeString(fromSeconds: currentTime)
        sessionTimerLabel.setText(timerText)
    }
    
    @objc private func handleTokenIncrements() {
        sessionTokens += AimTokenConversionManager.sharedInstance.currentTokenFactor()
        sessionTokensLabel.setText("\(sessionTokens)")
    }
}
