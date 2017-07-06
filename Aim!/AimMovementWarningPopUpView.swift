//
//  AimMovementWarningPopUpView.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-06.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimMovementWarningPopUpView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 1.0
    }
    
}
