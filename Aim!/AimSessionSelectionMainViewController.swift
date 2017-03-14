//
//  AimSessionSelectionMainViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable
class AimSessionSelectionMainViewController: UIViewController {
    
    let aimApplicationThemeFont24 = UIFont(name: "PhosphatePro-Inline", size: 24)
    let aimApplicationThemeOrangeColor = hexStringToUIColor(hex: "FF4A1c")
    let aimApplicationThemePurpleColor = hexStringToUIColor(hex: "1A1423")
    let aimApplicationNavBarThemeColor = hexStringToUIColor(hex: "1A1421")
    
    @IBOutlet weak var aimSessionCollectionView: UICollectionView!
    @IBOutlet weak var userLoginStatusIndicatorLabel: UILabel!
    @IBOutlet weak var aimTokenSumLabel: UILabel!
    @IBOutlet weak var aimTokenHourSeparaterImageView: UIImageView!
    @IBOutlet weak var aimHourSumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color: (For some reason I could not match the color I designed in Sketch 3 with the bg color I set in storyboard; therefore, I manually set hex color value onto each UIView element which needs a customized color)
        self.view.backgroundColor = aimApplicationThemePurpleColor
        
        aimTokenSumLabel.textColor = aimApplicationThemeOrangeColor
        aimTokenHourSeparaterImageView.backgroundColor = aimApplicationThemeOrangeColor
        aimHourSumLabel.textColor = aimApplicationThemeOrangeColor
        
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        // Putting Aim! logo onto nav bar:
        let navBarAimLogo = UIImage(named: "aim!LogoForNavigationBar")
        self.navigationItem.titleView = UIImageView.init(image: navBarAimLogo)
        // Setting nav bar item colors:
        self.navigationItem.leftBarButtonItem?.tintColor = aimApplicationThemeOrangeColor
        self.navigationItem.rightBarButtonItem?.tintColor = aimApplicationThemeOrangeColor
        
        // Use custom PhosphatePro-Inline font
        aimTokenSumLabel.font = aimApplicationThemeFont24
        aimHourSumLabel.font = aimApplicationThemeFont24
        
        aimSessionCollectionView.backgroundColor = aimApplicationThemePurpleColor
        
        // Check user login status
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLoginRegister), with: nil, afterDelay: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLoginRegister() {
        performSegue(withIdentifier: "showLoginPageSegue", sender: self)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError {
            print(signOutError)
        }
    }

    @IBAction func statusButtonPressed(_ sender: Any) {
        var userLoginStatus = false
        let userLoginEmail = FIRAuth.auth()?.currentUser?.email
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userLoginStatus = true
        } else {
            userLoginStatus = false
        }
        userLoginStatusIndicatorLabel.text = "\(userLoginStatus)\n\(userLoginEmail)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
