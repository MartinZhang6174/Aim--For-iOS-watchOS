//
//  AimStandardNavigationBarNotification.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-08.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import Foundation
import CWStatusBarNotification

class AimStandardNavigationBarNotification: CWStatusBarNotification {
    override init() {
        super.init()
        self.notificationStyle = .navigationBarNotification
        self.notificationAnimationType = .overlay
        self.notificationLabelBackgroundColor = aimApplicationThemeOrangeColor
        self.notificationLabelTextColor = aimApplicationThemePurpleColor
        self.notificationLabelFont = UIFont(name: "PhosphatePro-Inline", size: 14)
        self.notificationTappedBlock = {
            self.dismiss()
        }
    }
}
