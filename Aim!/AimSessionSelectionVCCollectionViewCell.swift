//
//  AimSessionSelectionVCCollectionViewCell.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

/*enum CellShadowConfiguration {
 case normal
 case highlighted
 }*/

class AimSessionSelectionVCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var backgroundBlackView: UIView!
    @IBOutlet weak var sessionSnaphotImageView: UIImageView!
    
    override func awakeFromNib() {
        
        /*let normalShadow = CellShadowConfiguration.normal
         
         switch normalShadow {
         case .normal:
         self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
         self.layer.shadowRadius = 5.0
         self.layer.shadowOpacity = 0.7
         self.layer.masksToBounds = false
         default:()
         }
         
         let highlightedShadow = CellShadowConfiguration.highlighted
         
         switch highlightedShadow {
         case .highlighted:
         self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
         self.layer.shadowRadius = 3.0
         self.layer.shadowOpacity = 1.0
         self.layer.masksToBounds = false
         default:()
         
         //self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
         //self.layer.shadowOpacity = 1.0
         
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
         self.layer.shadowOpacity = 0.7
         */
        //self.layer.masksToBounds = false
        // self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        //self.layer.shadowRadius = 5.0
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
