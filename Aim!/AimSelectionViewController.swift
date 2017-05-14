//
//  AimSelectionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2016-12-24.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

class AimSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // CODEREVIEW: Remove commented code.  Once you know which of the three lines below is CORRECT, remove the ones that are not.
      
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
//        self.tabBarController?.tabBar.barStyle = UIBarStyle.blackOpaque
        // Do any additional setup after loading the view.
    }

    // CODEREVIEW: This code has no new functionality.  Cleanup by removing code you don't need.
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
