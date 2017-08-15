//
//  AimAwardBadge.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-20.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

class AimAwardBadge {
    var badgeTitle: String?
    var badgeDescription: String?
    // More properties in future versions
    
    init(title: String, badgeDesc: String) {
        self.badgeTitle = title
        self.badgeDescription = badgeDesc
    }
}
