//
//  AimForceTouchSelectionSettingsTableViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-05-09.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimForceTouchSelectionSettingsTableViewController: UITableViewController {

    // CODEREVIEW: The only thing that this View Controller does is set the background colour for the tableView.  Consider deleting this class, and simply setting the tableView's background in Storyboard.

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = aimApplicationThemePurpleColor
    }
}
