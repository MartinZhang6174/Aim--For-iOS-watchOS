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
    dynamic var userName: String = ""
    let sessions = List<AimSession>()
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
