//
//  TrainJourneySettingsViewController.swift
//  MKHome
//
//  Created by charles on 06/01/2017.
//  Copyright © 2017 charles. All rights reserved.
//

import Foundation
import UIKit

class TrainJourneySettingsViewController: UIViewController {
    @IBOutlet var trainJourneyTableView: UITableView?

    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = AppData.sharedInstance

    override func viewWillAppear(_ animated: Bool) {
        trainJourneyTableView?.reloadData()
    }
}

extension TrainJourneySettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSettings.rail.getJourneys().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let journey = userSettings.rail.getJourneys()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell")!

        if let source = appSettings.stationMap[journey.originCRS],
            let destination = appSettings.stationMap[journey.destinationCRS] {
            let attributedSource = NSMutableAttributedString(string: source.stationName, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "normalText")!])
            let attributedDestination = NSAttributedString(string: destination.stationName, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "normalText")!])
            attributedSource.append(NSAttributedString(string: " → ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "alternativeText")!]))
            attributedSource.append(attributedDestination)
            cell.textLabel?.attributedText = attributedSource
        }

        return cell
    }
}

extension TrainJourneySettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let journey = userSettings.rail.getJourneys()[indexPath.row]
            userSettings.rail.removeJourney(journey)
            tableView.reloadData()
        }
    }
}
