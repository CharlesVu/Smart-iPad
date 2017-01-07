//
//  SettingsViewController.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: ThemableViewController
{
    override func refreshColors()
    {
        view.backgroundColor = colorScheme.alternativeBackground
    }
       
    @IBAction func onCloseClicked(button: UIButton)
    {
        dismiss(animated: true)
    }
}

