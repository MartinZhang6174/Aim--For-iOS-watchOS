//
//  SessionDurationManager.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-11.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation

// CODEREVIEW: The name of this struct is somewhat misleading.  It doesn't have any functionality that actually manages the duration of session objects, it doesn't maintain a list of session objects that it manages.  Consider renaming it so that you can make calls like AimSessionDuration.Default or AimSessionDuration.HourLong.  Could it be converted into an enum?
struct SessionDurationManager {
    let aimDefaultSessionDuration: TimeInterval = 25*60
    let aimHourLongSessionDuration: TimeInterval = 60*60
}
