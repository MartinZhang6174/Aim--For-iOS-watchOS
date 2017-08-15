//
//  AimEmailChangeFailureViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-05.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimEmailChangeFailureViewController: UIViewController {
    
    @IBOutlet weak var failureTextLabl: UILabel!
    
    var displayText = "We're sorry. We cannot reset the email address for an account with provider Login credentials."

    override func viewDidLoad() {
        super.viewDidLoad()

        failureTextLabl.text = displayText
    }

    @IBAction func dismissButtonClicked(_ sender: Any) {
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
