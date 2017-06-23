//
//  AimUserLite.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-22.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class AimUserLite: Object {
    dynamic var email: String = ""
    dynamic var hours: Float = 0.0
    dynamic var tokens: Float = 0.0
    
    convenience init(email: String, tokens: Float) {
        self.init()
        self.email = email
        self.tokens = tokens
    }
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    private static func createUser(in realm: Realm, withEmail email: String, andTokens tokens: Float) -> AimUserLite {
        let me = AimUserLite(email: email, tokens: tokens)
        try! realm.write {
            realm.add(me)
        }
        return me
    }
    
    @discardableResult
    static func defaultUser(in realm: Realm, withEmail email: String, andTokens tokens: Float) -> AimUserLite {
        return realm.object(ofType: AimUserLite.self, forPrimaryKey: email) ?? createUser(in: realm, withEmail: email, andTokens: tokens)
    }
}

