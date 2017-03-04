//
//  SettingsViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 6/28/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController {
    
    @IBOutlet var logoutCell: UITableViewCell!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Settings"
    }
    
}
