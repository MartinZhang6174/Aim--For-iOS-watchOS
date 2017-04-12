//
//  AimSessionSelectionMainViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

let aimApplicationThemeOrangeColor = hexStringToUIColor(hex: "FF4A1C")
let aimApplicationThemePurpleColor = hexStringToUIColor(hex: "1A1423")
let aimApplicationNavBarThemeColor = hexStringToUIColor(hex: "1A1421")

@IBDesignable
class AimSessionSelectionMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let aimApplicationThemeFont24 = UIFont(name: "PhosphatePro-Inline", size: 24)
    
    @IBOutlet weak var aimSessionCollectionView: UICollectionView!
    @IBOutlet weak var userLoginStatusIndicatorLabel: UILabel!
    @IBOutlet weak var aimTokenSumLabel: UILabel!
    @IBOutlet weak var aimTokenHourSeparaterImageView: UIImageView!
    @IBOutlet weak var aimHourSumLabel: UILabel!
    
    var sessionNameArray = ["Sep 17th, 2017", "May 6th, 2017", "Feb 19th, 2016", "Vocabulary for Engineering", "Aerodynamics Test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionNameArray.append("+")
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        var userLoginStatus = false
        let userLoginEmail = FIRAuth.auth()?.currentUser?.email
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userLoginStatus = true
        } else {
            userLoginStatus = false
        }
        userLoginStatusIndicatorLabel.text = "\(userLoginStatus)\n\(userLoginEmail)"
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returning the number of items in sessionDict plus one for the last cell is going to be an ADD button
        return sessionNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sessionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aimSessionSelectionCollectionViewCell", for: indexPath) as! AimSessionSelectionVCCollectionViewCell
        
        if indexPath.row == sessionNameArray.count-1 {
            
            
            // Deactivate label constraints relative to black view;
            sessionCell.sessionInfoLabelCenterYConstraintRelativeToBlackView.isActive = false
            sessionCell.sessionInfoLabelLeadingConstraintRelativeToBlackView.isActive = false
            sessionCell.sessionInfoLabelTrailingConstraintRelativeToBlackView.isActive = false
            
            // Rather, put constraints in relative to the entire cell
            sessionCell.sessionInfoLabel.centerYAnchor.constraint(equalTo: sessionCell.centerYAnchor).isActive = true
            sessionCell.sessionInfoLabel.leadingAnchor.constraint(equalTo: sessionCell.leadingAnchor).isActive = true
            sessionCell.sessionInfoLabel.trailingAnchor.constraint(equalTo: sessionCell.trailingAnchor).isActive = true
            
            // Remove black view from view hierarchy(spelling check?)
            sessionCell.backgroundBlackView.isHidden = true
            
            sessionCell.sessionInfoLabel.text = "+"
            sessionCell.sessionInfoLabel.font = UIFont(name: "PhosphatePro-Inline", size: 78)
            sessionCell.sessionInfoLabel.textColor = aimApplicationThemePurpleColor
            sessionCell.backgroundColor = aimApplicationThemeOrangeColor
            sessionCell.layer.cornerRadius = 5.0
            sessionCell.layer.shadowOpacity = 0.7
            sessionCell.layer.shadowOffset = CGSize(width: 7, height: 5)
        } else {
            
            // sessionCell.sessionInfoLabel.font = UIFont(name: "PhosphatePro-Inline", size: 64)
            // sessionCell.sessionInfoLabel.textColor = aimApplicationThemePurpleColor
            sessionCell.sessionInfoLabel.text = sessionNameArray[indexPath.row]
            sessionCell.backgroundColor = aimApplicationThemeOrangeColor
            sessionCell.layer.cornerRadius = 5.0
            sessionCell.layer.shadowOpacity = 0.7
            sessionCell.layer.shadowOffset = CGSize(width: 7, height: 5)
        }
        return sessionCell
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
