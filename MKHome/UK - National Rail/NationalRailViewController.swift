//
//  NationalRailViewController.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import Persistance
import HuxleySwift

class NationalRailViewViewController: UIViewController {
    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = NationalRail.AppData.sharedInstance

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var trainDestinationLabel: UILabel?

    fileprivate var departures: [Journey: HuxleySwift.Departures] = [:]
    fileprivate var currentJourneyIndex = -1

    override func viewDidLoad() {
        refreshTrains()

        Timer.every(1.minutes) {
            self.refreshTrains()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        Timer.every(15.seconds) {
            self.displayNextTrainJourney()
        }
    }
    
    func refreshTrains() {
        if userSettings.rail.getJourneys().count > 0 {
            for journey in userSettings.rail.getJourneys() {
                NationalRail.TrainInteractor().getTrains(from: journey.originCRS,
                                                         to: journey.destinationCRS) {
                                                            departures in

                                                            self.departures[journey] = departures
                                                            if self.currentJourneyIndex == -1 {
                                                                self.displayNextTrainJourney()
                                                            }
                                                            DispatchQueue.main.async {
                                                                self.tableView?.reloadData()
                                                            }
                }
            }
        }
    }

    func displayNextTrainJourney() {
        if userSettings.rail.getJourneys().count != 0 {
            currentJourneyIndex = (currentJourneyIndex + 1) % userSettings.rail.getJourneys().count

            let journey = userSettings.rail.getJourneys()[currentJourneyIndex]

            if let source = appSettings.stationMap[journey.originCRS],
                let destination = appSettings.stationMap[journey.destinationCRS] {
                let attributedSource = NSMutableAttributedString(string: source.stationName,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "normalText")!])
                let attributedDestination = NSAttributedString(string: destination.stationName,
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "normalText")!])
                attributedSource.append(NSAttributedString(string: " → ",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "alternativeText")!]))
                attributedSource.append(attributedDestination)
                trainDestinationLabel?.attributedText = attributedSource
            }
        }

        self.tableView?.reloadData()
    }

}

extension NationalRailViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentJourneyIndex == -1 {
            return 0
        }
        let currentJourney = userSettings.rail.getJourneys()[currentJourneyIndex]
        return departures[currentJourney]?.trainServices.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentJourney = userSettings.rail.getJourneys()[currentJourneyIndex]

        let service = departures[currentJourney]!.trainServices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell") as! TrainCell
        cell.arivalTime?.text = "Leaving at " + service.std! + " (\(Int(service.getJourneyDuration(toStationCRS: currentJourney.destinationCRS) / 60)) min)"

        if service.etd == "On time" || service.etd == service.std {
            cell.delay?.text = "On time"
            cell.delay?.textColor = UIColor(named: "positiveText")
        } else if service.etd == "Delayed" || service.etd == "Cancelled" {
            cell.delay?.text = service.etd
            cell.delay?.textColor =  UIColor(named: "errorText")
            cell.arivalTime?.textColor = UIColor(named: "errorText")
        } else {
            cell.delay?.text = "(\(Int(service.delay / 60)) min)"
            cell.delay?.textColor = UIColor(named: "warningText")
        }

        cell.backgroundColor = UIColor.clear
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.preservesSuperviewLayoutMargins = false

            cell.layoutMargins = .zero
            cell.separatorInset = .zero
        }

        if let platform = service.platform {
            cell.platform?.text = "Platform \(platform)"
            cell.platform?.textColor = UIColor(named: "alternativeText")
        } else {
            cell.platform?.textColor = UIColor(named: "warningText")
            cell.platform?.text = "Platform unknown"
        }

        cell.operatorImage?.image = UIImage(named: service.operatorCode!, in: nil, compatibleWith: nil)

        return cell
    }
}
