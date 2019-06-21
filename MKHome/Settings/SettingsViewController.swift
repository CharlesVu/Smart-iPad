//
//  SettingsViewController.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    @IBAction func onCloseClicked(button: UIButton) {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "alternativeText")
        header.contentView.backgroundColor = UIColor(named: "background")
    }
}
