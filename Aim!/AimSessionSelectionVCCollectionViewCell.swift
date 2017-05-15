//
//  AimSessionSelectionVCCollectionViewCell.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSessionSelectionVCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var backgroundBlackView: UIView!
    @IBOutlet weak var sessionSnaphotImageView: UIImageView!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if #available(iOS 10.0, *) {
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                let force = (touch?.force)!/(touch?.maximumPossibleForce)!
                print("Force: \(force)")
                if force == 1.0 {
                    super.touchesBegan(touches, with: event)
                }
            }
        }
    }
}
