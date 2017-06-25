//
//  ExtensionDelegate.swift
//  Aim! For watchOS Extension
//
//  Created by Martin Zhang on 2016-10-05.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Realm
import RealmSwift
import UserNotifications

@available(watchOSApplicationExtension 3.0, *)
class ExtensionDelegate: NSObject, WKExtensionDelegate {
        
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        let userNotificationCenterObj = UNUserNotificationCenter.current()
        userNotificationCenterObj.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if error != nil {
                print("User notification permission not granted: \(String(describing: error))")
            } else {
                print("User notification permission granted.")
            }
        }
        
        // Watch connectivity
        setupWatchConnectivity()
        
        do {
            // TRY SENDING SAMPLE CONTEXT TO PHONE
            try WCSession.default().updateApplicationContext(["sessions": "123"])
        } catch {
            print(error)
        }
        
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
}

// MARK: - Watch connectivity

@available(watchOSApplicationExtension 3.0, *)
extension ExtensionDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: " +
                "\(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " +
            "\(activationState.rawValue)")
    }
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if (message["UserAuthState"] as? Bool) != nil {
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.deleteAll()
                    print("User logged out, erasing all data from disk.")
                }
            } catch let error {
                print("Error deleting items on disk: \(error)")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let realm = try! Realm()
        let liteAimSession: AimSessionLite?
        
        if let currentUser = userInfo["CurrentUser"] as? [String: Any] {
            
            let userEmail = currentUser["Email"]
            let userTokens = currentUser["TotalTokens"]
            
            let user = AimUserLite(email: userEmail as! String, tokens: userTokens as! Float)
            
            if realm.object(ofType: AimUserLite.self, forPrimaryKey: userEmail) == nil {
                do {
                    try realm.write {
                        realm.add(user)
                    }
                } catch let err {
                    print("Error saving user onto disk: \(err)")
                }
            }
        }
        
        if let sessionsInfoFetchedInfo = userInfo["Session"] as? [String: Any] {
            if let title = sessionsInfoFetchedInfo["Title"] as? String,
                let hours = sessionsInfoFetchedInfo["Hours"] as? Int,
                let tokens = sessionsInfoFetchedInfo["Tokens"] as? Int,
                let date = sessionsInfoFetchedInfo["DateCreated"] as? Date,
                let priority = sessionsInfoFetchedInfo["Priority"] as? Bool {
                liteAimSession = AimSessionLite(sessionTitle: title, dateInitialized: date, priority: priority, tokens: tokens, hours: hours)
                if liteAimSession != nil {
                    if realm.object(ofType: AimSessionLite.self, forPrimaryKey: title) == nil {
                        do {
                            try realm.write {
                                realm.add(liteAimSession!)
                            }
                        } catch let error {
                            print("Error saving session on watch: \(error).")
                        }
                    } else {
                        print("Session already in place on disk.")
                        do {
                            try realm.write {
                                realm.object(ofType: AimSessionLite.self, forPrimaryKey: title)?.currentToken = tokens
                            }
                        } catch let modifyingErr {
                            print(modifyingErr)
                        }
                    }
                    
                }
            }
            
        }
        if (userInfo["UserAuthState"] as? Bool) != nil {
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.deleteAll()
                    print("User logged out, erasing all data from disk.")
                }
            } catch let error {
                print("Error deleting items on disk: \(error)")
            }
        }
    }
}
