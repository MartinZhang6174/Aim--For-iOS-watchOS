//
//  AimCustomRaisedButton.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-08.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import BFPaperButton

class AimCustomRaisedButton: BFPaperButton {

    override func awakeFromNib() {
        
        self.backgroundColor = aimApplicationThemePurpleColor
        
        self.shadowColor = aimApplicationThemePurpleColor
        
        self.loweredShadowOpacity = 0.7
        self.loweredShadowOffset = CGSize(width: 0, height: 1)
        
        self.liftedShadowOpacity = 0.7
        self.liftedShadowOffset = CGSize(width: 2, height: 4)
        
        self.touchDownAnimationDuration = 0.2
        self.touchUpAnimationDuration = 0.3
        
        self.cornerRadius = 5.0
        
        self.tapCircleColor = aimApplicationThemePurpleColor
        
        self.tintColor = aimApplicationThemeOrangeColor
        
    }
    
}
