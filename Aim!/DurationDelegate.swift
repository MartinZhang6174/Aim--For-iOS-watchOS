//
//  DurationDelegate.swift
//  Aim!
//
//  Created by Nelson Chow on 2016-10-18.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import Foundation

protocol DurationDelegate {
    func beginCustomSession(duration: TimeInterval)
    func beginEndlessSession()
}
