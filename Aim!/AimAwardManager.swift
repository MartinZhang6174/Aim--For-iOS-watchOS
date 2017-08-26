//
//  AimAwardManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-20.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation
import Firebase

class AimAwardManager {
    
    lazy var fireRef = Database.database().reference()
    
    var awardDescriptionsDict = ["ThreeDayBadge": "Started 3 Aim! sessions in a day.", "FourDayBadge": "Started 4 Aim! sessions in a day.", "FiveDayBadge": "Started 5 Aim! sessions in a day.", "FacebookBadge": "Logged in with Facebook.", "PhotoLibraryBadge": "Picked a photo from library.", "GoogleBadge": "Logged in with Google.", "ReminderBadge": "Set reminders to use Aim!", "BatteryLowBadge": "Started session in low battery mode.", "CameraBadge": "Took a photo for an Aim! session."]
    
    func getAwardDescription(for awardName: String) -> String {
        if let awardDesc = awardDescriptionsDict[awardName] {
            return awardDesc
        }
        
        return "???"
    }
    
    /*func userAlreadyHasBadge(badgeTitle: String) {
        fireRef.child("user").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            print("Checking sources...")
            if snapshot.hasChild(badgeTitle) {
                print("HAS THIS BADGE!")
            } else {
                print("AIN'T HAVE NO BADGE LIKE THIS.")
            }
        })
    }*/
    
    func awardUserThreeBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("ThreeDayBadge").setValue(true)
        })
    }
    
    func awardUserFourBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FourDayBadge").setValue(true)
        })
    }
    
    func awardUserFiveBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FiveDayBadge").setValue(true)
        })
    }
    
    func awardUserBatteryBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("BatteryLowBadge").setValue(true)
        })
    }
    
    func awardUserFacebookBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FacebookBadge").setValue(true)
        })
    }
    
    func awardUserPhotoLibraryBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("PhotoLibraryBadge").setValue(true)
        })
    }
    
    func awardUserReminderBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("ReminderBadge").setValue(true)
        })
    }
    
    func awardUserGoogleBadge () {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("GoogleBadge").setValue(true)
        })
    }
}
