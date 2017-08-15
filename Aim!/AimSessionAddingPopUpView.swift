//
//  AimSessionAddingPopUpView
//  Aim!
//
//  Created by Martin Zhang on 2017-04-15.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

@IBDesignable
class AimSessionAddingPopUpView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 1.0
    }
}
