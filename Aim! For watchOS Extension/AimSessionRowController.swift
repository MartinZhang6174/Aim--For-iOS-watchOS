//
//  AimSessionRowController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-27.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import WatchKit

class AimSessionRowController: NSObject {
    @IBOutlet var sessionTitleLabel: WKInterfaceLabel!
    
    var session: AimSession! {
        didSet {
            sessionTitleLabel.setText(session.title)
        }
    }
}
