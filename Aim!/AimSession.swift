//
//  AimSession.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-04-13.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import RealmSwift
// Unable to import Realm/RealmSwift, unchecking the Aim! Extension target solves the problem, but doesn't Realm support watchOS?!

class AimSession: NSObject {
    // Properties:
    // Time frame:------------> When user hits CREATE SESSION, she needs to fill in a TITLE, PRIORITY, and a PHOTO. The system will generate the current time object to fill in the AimSession initializer
    var title: String?
    var currentToken: Int = 0
    var currentTimeAccumulated = TimeInterval()
    var hoursAccumulated: Double = 0.0
    var imageURL: String?
    
    var isPrioritized = Bool()
    
    let dateCreated: Date?
    
    init(sessionTitle: String?, dateInitialized: Date?, url: String?, priority: Bool) {
        self.title = sessionTitle
        self.dateCreated = dateInitialized
        self.imageURL = url
        self.isPrioritized = priority
    }
}
