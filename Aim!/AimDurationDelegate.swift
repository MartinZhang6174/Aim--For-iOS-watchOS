//
//  AimDurationDelegate.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-18.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import Foundation

// CODEREVIEW: This protocol has an inconsistent name.  Your other protocols are named AimXxxx.
protocol AimDurationDelegate {
    func beginCustomSession(durationInSeconds: TimeInterval)
    func beginEndlessSession()
}
