//
//  AimUser.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class AimUser: Object {
    dynamic var userName: String? = nil
    dynamic var email: String = ""
    dynamic var tokenPool: Float = 0.0
    let sessions = List<AimSession>()
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    convenience init(registeredEmail: String) {
        self.init()
        self.email = registeredEmail
    }
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    private static func createUser(in realm: Realm, withEmail email: String) -> AimUser {
        let me = AimUser(registeredEmail: email)
        try! realm.write {
            realm.add(me)
        }
        return me
    }
    
    @discardableResult
    static func defaultUser(in realm: Realm, withEmail email: String) -> AimUser {
        return realm.object(ofType: AimUser.self, forPrimaryKey: email) ?? createUser(in: realm, withEmail: email)
    }
}
