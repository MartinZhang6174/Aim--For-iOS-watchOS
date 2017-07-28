//
//  AppDelegate.swift
//  Aim!
//
//  Created by Martin Zhang on 2016-10-05.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import WatchConnectivity
import RealmSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let NotificationAddedSessionOnPhone = "AddedSessionOnPhone"
    let NotificationAddedSessionOnWatch = "AddedSessionOnWatch"
    let NotificationUpdatedTokenFromWatch = "ReceivedUpdatedTokensFromWatchNotification"
    
    var window: UIWindow?
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = aimApplicationThemeOrangeColor
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // Loading user preferencess and applications of them:
        let userPrefersLightStatusBarStyle = UserDefaults.standard.bool(forKey: "LightStatusBarStyle")
        if userPrefersLightStatusBarStyle == true {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        
        // Register for local push notifications:
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
        }
        
        // Configure a FIRApp instance
        FirebaseApp.configure()
        
        // Setting up watch connectivity
        setupWatchConnectivity()
        
        // Setting up notification center for future notifications to session syncing
        setupNotificationCenter()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    // CODEREVIEW: Remove any code which you are not using.  All the methods below have empty implementations.
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func setupNotificationCenter() {
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationAddedSessionOnPhone), object: nil, queue: nil) { (notification:Notification) -> Void in
            self.sendSessionsToWatch(notification)
        }
    }
}

// MARK: - Watch connectivity

extension AppDelegate: WCSessionDelegate {
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC Session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC Session did deactivate")
        WCSession.default().activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: " +
                "\(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " +
            "\(activationState.rawValue)")
    }
    
    func sendSessionsToWatch(_ notification: Notification) {
        
        if WCSession.isSupported() {
            
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let userInfoFetched = userInfo["UserInfo"] as? [String: Any] {
            if let tokens = userInfoFetched["Tokens"] as? Float, let hours = userInfoFetched["Hours"] as? Float {
                let realm = try! Realm()
                
                if let currentRealmUser = realm.object(ofType: AimUser.self, forPrimaryKey: Auth.auth().currentUser?.email) {
                    do {
                        try! realm.write {
                                currentRealmUser.tokenPool = tokens
                            realm.add(currentRealmUser, update: true)
                        }
                        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationUpdatedTokenFromWatch), object: self)
                    }
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
    }
}

