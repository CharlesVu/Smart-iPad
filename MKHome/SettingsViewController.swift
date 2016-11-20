//
//  SettingsViewController.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController
{
    fileprivate var colorScheme = ColorScheme.solarizedLight
    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = AppData.sharedInstance

    @IBOutlet var trainJourneyTableView: UITableView?
    
    override func viewDidLoad()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        self.trainJourneyTableView?.layer.borderWidth = 1
        self.trainJourneyTableView?.layer.borderColor = colorScheme.background.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.trainJourneyTableView?.reloadData()
    }
    
    @IBAction func onCloseClicked(button: UIButton)
    {
        self.dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userSettings.getJourneys().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let journey = userSettings.getJourneys()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell")!
        
        if let source = appSettings.stationMap[journey.originCRS],
            let destination = appSettings.stationMap[journey.destinationCRS]
        {
            let attributedSource = NSMutableAttributedString(string: source, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
            let attributedDestination = NSAttributedString(string: destination, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
            attributedSource.append(NSAttributedString(string: " → ", attributes:[NSForegroundColorAttributeName: colorScheme.alternativeText]))
            attributedSource.append(attributedDestination)
            cell.textLabel?.attributedText = attributedSource
        }

        cell.backgroundColor = colorScheme.alternativeBackground
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let journey = userSettings.getJourneys()[indexPath.row]
            userSettings.removeJourney(journey)
            tableView.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
