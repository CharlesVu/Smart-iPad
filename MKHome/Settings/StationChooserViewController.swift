//
//  StationChooserViewController.swift
//  MKHome
//
//  Created by charles on 20/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit
import Persistance

class StationChooserViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?

    fileprivate let appSettings = AppData.sharedInstance
    fileprivate var filteredStations: [TrainStation]?

    var selectedCRS: String?
    var previousCRS: String?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Arrival" {
            if let destination = segue.destination as? StationChooserViewController {
                destination.previousCRS = self.selectedCRS
            }
        }
    }
}

extension StationChooserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filteredStations = filteredStations {
            selectedCRS = filteredStations[indexPath.row].crsCode
        } else {
            selectedCRS = appSettings.stationList[indexPath.row].crsCode
        }

        if let previousCRS = previousCRS, let selectedCRS = selectedCRS {
            // Todo : Validate train journey by calling client to see if there is at least a train
            UserSettings.sharedInstance.rail.addJourney(Journey(originCRS: previousCRS, destinationCRS: selectedCRS))
            if let viewController = self.navigationController?.viewControllers[1] {
                _ = self.navigationController?.popToViewController(viewController, animated: true)
            }
        } else {
            self.performSegue(withIdentifier: "Arrival", sender: nil)
        }
    }
}

extension StationChooserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredStations = filteredStations {
            return filteredStations.count
        } else {
            return appSettings.stationList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station: TrainStation
        if let filteredStations = filteredStations {
            station = filteredStations[indexPath.row]
        } else {
            station = appSettings.stationList[indexPath.row]
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell")!

        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.crsCode

        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.preservesSuperviewLayoutMargins = false

            cell.layoutMargins = .zero
            cell.separatorInset = .zero
        }

        return cell
    }
}

extension StationChooserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        let lowercaseSearchText = searchText.lowercased()
        if searchText != "" {
            filteredStations = appSettings.stationList.filter({ (element) -> Bool in
                return element.stationName.lowercased().contains(lowercaseSearchText) || element.crsCode.lowercased().contains(lowercaseSearchText)
            })
        } else {
            filteredStations = nil
        }
        self.tableView?.reloadData()
    }
}
