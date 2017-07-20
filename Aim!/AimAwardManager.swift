//
//  AimAwardManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-20.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

class AimAwardManager {
    
    var awardDescriptionsDict = ["ThreeDayBadge": "You earn this badge by completing three Aim! sessions in a single day.", "FourDayBadge": "You earn this badge by completing four Aim! sessions in a single day.", "FiveDayBadge": "You earn this badge by completing five Aim! sessions in a single day."]
    
    func getAwardDescription(for awardName: String) -> String {
        if let awardDesc = awardDescriptionsDict[awardName] {
            return awardDesc
        }
        
        return "???"
    }
    
}
