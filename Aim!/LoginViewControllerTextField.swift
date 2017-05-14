//
//  LoginViewControllerTextField.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-02-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

@IBDesignable
class LoginViewControllerTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
      
        self.layer.backgroundColor = UIColor(red: 26, green: 20, blue: 35).cgColor
        self.layer.cornerRadius = 5.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}

// CODEREVIEW: Consider replacing this UIColor extension with hexStringToUIColor that you use in your other classes.  You can add alpha as an optional parameter to hexStringToUIColor.  Try to keep similar functionality consistent across your classes.

// HEX: 1A1423  RGB: (26,20,35)
// Extension for the purpleish colour (with alpha: 0.2)
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 0.2)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
