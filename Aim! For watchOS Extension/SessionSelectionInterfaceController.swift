//
//  SessionSelectionInterfaceController.swift
//  Aim!
//
//  Created by Martin Zhang on 2016-10-27.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation


class SessionSelectionInterfaceController: WKInterfaceController {

    @IBOutlet var priviousSessionButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        priviousSessionButton.setTitle("Aug 27, 2016")
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
