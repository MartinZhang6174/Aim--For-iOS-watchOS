//
//  AimSession.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-04-13.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class AimSession: Object {
    // MARK: - Persisting properties
    dynamic var title = ""
    dynamic var imageURL: String? = nil
    dynamic var currentToken = 0
    dynamic var hoursAccumulated = 0
    dynamic var currentTimeAccumulated = TimeInterval()
    dynamic var dateCreated = Date()
    dynamic var isPrioritized = false
    
    convenience init(sessionTitle: String, dateInitialized: Date, sessionImageURLString: String, priority: Bool) {
        self.init()
        
        self.title = sessionTitle
        self.dateCreated = dateInitialized
        self.imageURL = sessionImageURLString
        self.isPrioritized = priority
    }
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "imageURL"
    }
    
//    private static func save(to realm: Realm, with id: String) -> AimSession {
//    
//        
//    
//    }
//    
//    static func persistInRealm(realm: Realm, with id: String) -> AimSession {
//    
//        return realm.object(ofType: AimSession.self, forPrimaryKey: id)
//    
//    
//    }
}
