//
//  AimStandardStatusBarNotification.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-20.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import CWStatusBarNotification

class AimStandardStatusBarNotification: CWStatusBarNotification {
    override init() {
        super.init()
        self.notificationStyle = .statusBarNotification
        self.notificationLabelBackgroundColor = aimApplicationThemeOrangeColor
        self.notificationLabelTextColor = aimApplicationThemePurpleColor
        self.notificationLabelFont = UIFont(name: "PhosphatePro-Inline", size: 14)
        self.notificationAnimationType = .overlay
        self.notificationAnimationInStyle = .top
        self.notificationAnimationOutStyle = .bottom
    }
}
