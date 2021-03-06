//
//  AimDurationDelegate.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-18.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import Foundation

protocol AimDurationDelegate {
    func beginCustomSession(durationInSeconds: TimeInterval)
    func beginEndlessSession()
}
