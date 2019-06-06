//
//  ViewController.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import UIKit
import ForecastIO
import CoreLocation
import HomeKit
import HuxleySwift
import Persistance

class RootViewController: UIViewController {
    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = AppData.sharedInstance

    // Weather Stuff
    @IBOutlet weak var currentTime: UILabel?
    @IBOutlet weak var currentDate: UILabel?

    let dateCellFormatter = DateFormatter()
    let currentDayCellFormatter = DateFormatter()

    // Train Stuff
    fileprivate var departures: [Journey: HuxleySwift.Departures] = [:]
    fileprivate var currentJourneyIndex = -1
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var trainDestinationLabel: UILabel?
    @IBOutlet weak var lightView: LightView?

    // Home Stuff    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        currentDayCellFormatter.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshTrains()
        refreshTime()

        Timer.every(15.seconds) {
            self.displayNextTrainJourney()
        }

        Timer.every(10.second) {
            self.refreshTime()
        }

        Timer.every(1.minutes) {
            self.refreshTrains()
        }
    }

    func refreshTime() {
        currentTime?.text = dateCellFormatter.string(from: Date())
        currentDate?.text = currentDayCellFormatter.string(from: Date())
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

extension RootViewController: UITableViewDataSource {
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
