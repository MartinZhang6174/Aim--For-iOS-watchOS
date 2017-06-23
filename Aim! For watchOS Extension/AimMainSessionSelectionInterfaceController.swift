//
//  AimMainSessionSelectionInterfaceController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-27.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import RealmSwift
import Realm

class AimMainSessionSelectionInterfaceController: WKInterfaceController {
    
    @IBOutlet var sessionTable: AimSessionSelectionTable!

    var sessionTableDataSource: Results<AimSessionLite>?
    let realm = try! Realm()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        sessionTableDataSource = realm.objects(AimSessionLite.self)
        updateDisplay()
    }
    
    private func updateDisplay() {
        if let dataSource = sessionTableDataSource {
            let numberOfSessions = dataSource.count
            if numberOfSessions > 0 {
                sessionTable.setNumberOfRows(numberOfSessions, withRowType: "AimSessionRowType")
                for index in 0..<(numberOfSessions) {
                    if let rowController = sessionTable.rowController(at: index) as? AimSessionRowController {
                        let session = sessionTableDataSource?[index]
                        rowController.session = session
                    }
                }
            } else {
                print("No rows to display here.")
            }
        }
    }
    
    override func didAppear() {
        sendTokensInfoToCompanion()
    }
    
    private func sendTokensInfoToCompanion() {
        // ONLY UPDATING TOKENS, NEED TO IMPLEMENT OTHER ELEMENTS' SYNCHRONIZATION
        if let user = realm.objects(AimUserLite.self).first {
            let currentTokensOnWatch = user.tokens
            let currenHoursOnWatch = user.hours
            
            let userValues = ["Tokens": currentTokensOnWatch, "Hours": currenHoursOnWatch] as [String: Any]
            
            do {
                try WCSession.default().transferUserInfo(["UserInfo": userValues])
            } catch let err {
                print("Error communicating with ccmpanion device: \(err)")
            }
        }
    }
    
//    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
//        let session = sessionTableDataSource?[rowIndex]
//        presentController(withName: "Session", context: session)
//    }
//    
    @IBAction func refreshButtonClicked() {
        updateDisplay()
    }
    
//    @objc private func cleanItemsOnDisk() {
//        let realm = try! Realm()
//        realm.deleteAll()
//    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if let rowController = sessionTable.rowController(at: rowIndex) as? AimSessionRowController {
            return rowController.session
        }
        return nil
    }
}
