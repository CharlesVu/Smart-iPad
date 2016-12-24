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
    @IBOutlet var cityWeatherTableView: UITableView?

    override func viewDidLoad()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        self.trainJourneyTableView?.layer.borderWidth = 1
        self.trainJourneyTableView?.layer.borderColor = colorScheme.background.cgColor

        self.cityWeatherTableView?.layer.borderWidth = 1
        self.cityWeatherTableView?.layer.borderColor = colorScheme.background.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.trainJourneyTableView?.reloadData()
        self.cityWeatherTableView?.reloadData()
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
        if trainJourneyTableView == tableView
        {
            return userSettings.rail.getJourneys().count
        }
        else
        {
            return userSettings.weather.getCities().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if trainJourneyTableView == tableView
        {
            let journey = userSettings.rail.getJourneys()[indexPath.row]
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
        else
        {
            let city = userSettings.weather.getCities()[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
            cell.textLabel?.text = city.name
            cell.backgroundColor = colorScheme.alternativeBackground
            cell.textLabel?.textColor = colorScheme.normalText

            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            if trainJourneyTableView == tableView
            {
                let journey = userSettings.rail.getJourneys()[indexPath.row]
                userSettings.rail.removeJourney(journey)
            }
            else
            {
                let city = userSettings.weather.getCities()[indexPath.row]
                userSettings.weather.removeCity(city)
            }
            tableView.reloadData()
        }
    }
}
