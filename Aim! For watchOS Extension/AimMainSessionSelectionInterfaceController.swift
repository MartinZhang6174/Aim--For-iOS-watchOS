//
//  AimMainSessionSelectionInterfaceController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-27.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class AimMainSessionSelectionInterfaceController: WKInterfaceController {

    @IBOutlet var sessionTable: AimSessionSelectionTable!
    
//    var s1 = AimSession(sessionTitle: "English HW", dateInitialized: nil, url: nil, priority: false)
//    var s2 = AimSession(sessionTitle: "Physics Proj", dateInitialized: nil, url: nil, priority: true)
//    var s3 = AimSession(sessionTitle: "Math Tutor", dateInitialized: nil, url: nil, priority: false)
//    var s4 = AimSession(sessionTitle: "iOS Program", dateInitialized: nil, url: nil, priority: true)
    var sessionArray = [AimSession]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let realm = try! Realm()
        let dataSource = realm.objects(AimSession.self)
        
//        sessionArray.append(s1)
//        sessionArray.append(s2)
//        sessionArray.append(s3)
//        sessionArray.append(s4)
        
        // Configure interface objects here.
        updateDisplay()
    }
    
    private func updateDisplay() {
        let numberOfSessions = sessionArray.count
        if numberOfSessions > 0 {
            for index in 0...(numberOfSessions-1) {
                if let rowController = sessionTable.rowController(at: index) as? AimSessionRowController {
                    let session = sessionArray[index]
                    rowController.session = session
                }
            }
        } else {
            print("No rows to display here.")
        }
        sessionTable.setNumberOfRows(numberOfSessions, withRowType: "AimSessionRowType")
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if let rowController = sessionTable.rowController(at: rowIndex) as? AimSessionRowController {
            return rowController.session
        }
        return nil
    }
}
