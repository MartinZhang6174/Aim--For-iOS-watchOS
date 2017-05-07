//
//  AimSettingsViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set navigation bar bg colour(tintcolor is what apple calls it)
        // self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        // Set back groudn view colour
        self.view.backgroundColor = aimApplicationThemeOrangeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
