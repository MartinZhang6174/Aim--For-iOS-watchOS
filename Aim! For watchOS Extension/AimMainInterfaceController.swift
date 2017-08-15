//
//  AimMainInterfaceController.swift
//  Aim! For watchOS Extension
//
//  Created by Martin Zhang on 2016-10-05.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import WatchKit
import Foundation
import Realm
import RealmSwift

class AimMainInterfaceController: WKInterfaceController {
    
    @IBOutlet var userTokenSumLabel: WKInterfaceLabel!
    @IBOutlet var userHourSumLabel: WKInterfaceLabel!
    @IBOutlet var toSessionsButton: WKInterfaceButton!
    @IBOutlet var toAwardsButton: WKInterfaceButton!
    
    var aimUser: Results<AimUserLite>?
    let realm = try! Realm()
    
    override func didAppear() {
        aimUser = realm.objects(AimUserLite.self)
        if let userTokens = aimUser?.first?.tokens {
            userTokenSumLabel.setText("\(userTokens)")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    
}
