//
//  AimQuoteView.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-04-30.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimQuoteView: UIView {

    override func awakeFromNib() {
//        super.awakeFromNib()
        self.backgroundColor = aimApplicationThemePurpleColor
        
        self.layer.cornerRadius = 5.0
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
