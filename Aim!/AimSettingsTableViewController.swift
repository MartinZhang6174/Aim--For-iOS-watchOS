//
//  AimSettingsTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-08.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar bg colour(tintcolor is what apple calls it)
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        self.navigationController?.navigationBar.tintColor = aimApplicationThemeOrangeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
