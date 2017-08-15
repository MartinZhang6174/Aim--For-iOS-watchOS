//
//  AimSessionDurationInfoDelegate.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-11.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

protocol AimSessionDurationInfoDelegate {
    func getSessionDuration(_ durationInSeconds: TimeInterval)
    func getSessionDurationForSessionWithoutDurationLimits()
}
