//
//  AimTokenConversionManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-15.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

struct AimTokenConversionManager {
    
    static let sharedInstance: AimTokenConversionManager = AimTokenConversionManager()
    
    // A system built-in conversion factor that measures the number of tokens you get for a minute of Aiming!
    func currentTokenFactor() -> Float {
        return 3.0
    }
    
}
