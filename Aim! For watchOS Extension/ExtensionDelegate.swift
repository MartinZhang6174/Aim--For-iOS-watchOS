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

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        // Realm
//        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.martinzhang.Aim")!
//        let realmPath = directory.path.appending("db.realm")
//        
//        let configuration = RLMRealmConfiguration.default()
//        configuration.fileURL = URL(fileURLWithPath: realmPath)
//        RLMRealmConfiguration.setDefault(configuration)
        
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
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let realm = try! Realm()
        let liteAimSession: AimSessionLite?
        if let sessionsInfoFetchedFromContext = applicationContext["Session"] as? [String: Any] {
            if let title = sessionsInfoFetchedFromContext["Title"] as? String,
                let hours = sessionsInfoFetchedFromContext["Hours"] as? Int,
                let tokens = sessionsInfoFetchedFromContext["Tokens"] as? Int,
                let date = sessionsInfoFetchedFromContext["DateCreated"] as? Date,
                let priority = sessionsInfoFetchedFromContext["Priority"] as? Bool {
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
    }
}
