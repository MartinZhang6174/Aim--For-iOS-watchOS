//
//  AimSessionSelectionMainViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimSessionSelectionMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Check user login status
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLoginRegister), with: nil, afterDelay: 0)
        }
        print("Log")
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
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userLoginStatus = true
        } else {
            userLoginStatus = false
        }
        print(userLoginStatus)
        print(FIRAuth.auth()?.currentUser?.email)
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
