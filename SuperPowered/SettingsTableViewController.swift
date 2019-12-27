//
//  SettingsTableViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 21.10.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBAction func darkModeSwitchPressed(_ sender: UISwitch) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        settingsLabel.font = UIFont(name: montserratSemiBold, size: 20)
        darkModeLabel.font = UIFont(name: montserratMedium, size: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        tabBarController?.tabBar.barTintColor = UIColor.barBackgroundColor
        tabBarController?.tabBar.tintColor = UIColor.textColor
        tableView.separatorColor = UIColor.linesColor
        settingsLabel.textColor = UIColor.textColor
        self.view.backgroundColor = UIColor.backgroundColor
        tableView.backgroundColor = UIColor.backgroundColor
        darkModeLabel.textColor = UIColor.textColor
        darkModeSwitch.onTintColor = UIColor.AppColors.green
        
    }
}
