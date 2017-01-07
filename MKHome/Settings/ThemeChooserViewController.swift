//
//  ThemeChooserViewController.swift
//  MKHome
//
//  Created by Charles Vu on 07/01/2017.
//  Copyright © 2017 charles. All rights reserved.
//

import Foundation
import UIKit

class ThemeChooserViewController: ThemableViewController
{
    @IBOutlet var tableView: UITableView?
    fileprivate let schemes = Array(ColorScheme.allValues.keys)
    
    override func refreshColors()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        tableView?.reloadData()

        navigationController?.navigationBar.tintColor = colorScheme.normalText
        navigationController?.navigationBar.barTintColor = colorScheme.alternativeBackground
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:colorScheme.normalText]

    }

    override func viewWillAppear(_ animated: Bool)
    {
        tableView?.reloadData()
    }
}

extension ThemeChooserViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return schemes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let scheme = schemes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "schemeCell")!
        cell.textLabel?.text = scheme
        cell.backgroundColor = colorScheme.alternativeBackground
        cell.textLabel?.textColor = colorScheme.normalText

        return cell
    }
}

extension ThemeChooserViewController: UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let scheme = schemes[indexPath.row]
        if let colorScheme = ColorScheme.allValues[scheme]
        {
            UserSettings.sharedInstance.colorScheme.scheme = colorScheme
        }
    }
}
