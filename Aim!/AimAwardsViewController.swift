//
//  AimAwardsViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimAwardsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
    
        self.view.backgroundColor = aimApplicationThemePurpleColor
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // CODEREVIEW: Remove code you don't need.
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
