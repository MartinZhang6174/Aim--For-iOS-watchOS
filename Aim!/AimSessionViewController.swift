//
//  AimSessionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSessionViewController: UIViewController {

//    var seconds = 60
    var aimTimer = Timer()
    var secondsElapsed = 0
    
    var sessionTitleStringValue = ""
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        sessionTimerLabel.text = String(secondsElapsed)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionTitleLabel.text = sessionTitleStringValue
    }
    
    @IBAction func startSessionButtonPressed(_ sender: Any) {
        aimTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAimSessionTimerLabel), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseSessionButtonClicked(_ sender: Any) {
        aimTimer.invalidate()
    }
    
    @IBAction func terminateSessionButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateAimSessionTimerLabel() {
        secondsElapsed += 1
        sessionTimerLabel.text = String(secondsElapsed)
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
