//
//  AimSessionInterfaceController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-27.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation

class AimSessionInterfaceController: WKInterfaceController {
    
    @IBOutlet var sessionTitleLabel: WKInterfaceLabel!
    @IBOutlet var sessionTimer: WKInterfaceTimer!
    
    var session: AimSessionLite!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let context = context as? AimSessionLite {
            session = context
            
            setTitle(session.title)
            sessionTitleLabel.setText(session.title)
        }
        sessionTimer.start()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
