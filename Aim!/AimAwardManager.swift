//
//  AimAwardManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-20.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

class AimAwardManager {
    
    var awardDescriptionsDict = ["ThreeDayBadge": "Earn this badge by completing 3 Aim! sessions in a day.", "FourDayBadge": "Earn this badge by completing 4 Aim! sessions in a day.", "FiveDayBadge": "Earn this badge by completing 5 Aim! sessions in a day."]
    
    func getAwardDescription(for awardName: String) -> String {
        if let awardDesc = awardDescriptionsDict[awardName] {
            return awardDesc
        }
        
        return "???"
    }
    
}
