//
//  AimAwardsBadgeCollectionViewCell.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-07-12.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import MarqueeLabel

class AimAwardsBadgeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeUIView: UIView!
    @IBOutlet weak var badgeInfoUIView: UIView!
    
    var isFlipped = false
    
    @IBAction func flipBadge(_ sender: Any) {
        if isFlipped == false {
            UIView.transition(from: badgeUIView, to: badgeInfoUIView, duration: 0.7, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            isFlipped = true
        } else if isFlipped == true {
            UIView.transition(from: badgeInfoUIView, to: badgeUIView, duration: 0.7, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            isFlipped = false
        }
    }
    
}
