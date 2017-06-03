//
//  AimSessionLite.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-02.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class AimSessionLite: Object {
    dynamic var title = ""
    dynamic var currentToken = 0
    dynamic var hoursAccumulated = 0
    dynamic var dateCreated = Date()
    dynamic var isPrioritized = false
    
    convenience init(sessionTitle: String, dateInitialized: Date, priority: Bool, tokens: Int, hours: Int) {
        self.init()
        
        self.title = sessionTitle
        self.dateCreated = dateInitialized
        self.isPrioritized = priority
        self.currentToken = tokens
        self.hoursAccumulated = hours
    }
}
