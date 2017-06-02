//
//  AimSessionLite.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-02.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSessionLite: NSObject {
    var title = ""
    var imageURL: String? = nil
    var currentToken = 0
    var hoursAccumulated = 0
    var currentTimeAccumulated = TimeInterval()
    var dateCreated = Date()
    var isPrioritized = false
    
    init(sessionTitle: String, dateInitialized: Date, sessionImageURLString: String, priority: Bool, tokens: Int, hours: Int, interval: TimeInterval) {
        self.title = sessionTitle
        self.imageURL = sessionImageURLString
        self.dateCreated = dateInitialized
        self.isPrioritized = priority
        self.currentToken = tokens
        self.hoursAccumulated = hours
        self.currentTimeAccumulated = interval
    }
}
