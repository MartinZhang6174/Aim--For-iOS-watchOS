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
    
    let fireRef = Database.database().reference()
    
    var awardDescriptionsDict = ["ThreeDayBadge": "Earn this badge by completing 3 Aim! sessions in a day.", "FourDayBadge": "Earn this badge by completing 4 Aim! sessions in a day.", "FiveDayBadge": "Earn this badge by completing 5 Aim! sessions in a day."]
    
    func getAwardDescription(for awardName: String) -> String {
        if let awardDesc = awardDescriptionsDict[awardName] {
            return awardDesc
        }
        
        return "???"
    }
    
    /*func userAlreadyHasBadge(badgeTitle: String) -> Bool {
        fireRef.child("user").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(badgeTitle) {
                return true
            }
        })
        return false
    }*/
    
    func awardUserThreeBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("ThreeDayBadge") == false {
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("ThreeDayBadge").setValue(true)
            }
        })
    }
    
    func awardUserFourBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("FourDayBadge") == false {
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FourDayBadge").setValue(true)
            }
        })
    }
    
    func awardUserFiveBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("FiveDayBadge") == false {
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FiveDayBadge").setValue(true)
            }
        })
    }
    
    func awardUserBatteryBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("BatteryLowBadge") == false {
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("BatteryLowBadge").setValue(true)
            }
        })
    }
    
    func awardUserFacebookBadge() {
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("FacebookBadge") == false {
                self.fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FacebookBadge").setValue(true)
            }
        })
    }
}
