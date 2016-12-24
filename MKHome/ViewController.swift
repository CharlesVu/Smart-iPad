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
import Huxley

class ViewController: UIViewController
{
    fileprivate var colorScheme = ColorScheme.solarizedDark {
        didSet {
            refreshColors()
            tableView?.reloadData()
            weatherView?.colorScheme = colorScheme
        }
    }

    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = AppData.sharedInstance

    // Weather Stuff
    private let client = DarkSkyClient(apiKey: Configuration().darkSkyApiToken)
    fileprivate var weatherMap: [String: Forecast] = [:]
    fileprivate var currentLocation: String = ""
    private var currentAreaIndex = 0

    @IBOutlet weak var currentTime: UILabel?
    @IBOutlet weak var currentDate: UILabel?
    @IBOutlet weak var weatherView: WeatherView?

    let dateCellFormatter = DateFormatter()
    let currentDayCellFormatter = DateFormatter()
    
    // Train Stuff
    fileprivate var departures: [Journey: Huxley.Departures] = [:]
    fileprivate var currentJourneyIndex = -1
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var trainDestinationLabel: UILabel?

    // Home Stuff

    // Stuff that need to move from here
    fileprivate let areasOfInterest = ["Milton Keynes, UK", "Leicester Square Station, London"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        currentDayCellFormatter.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
        
        client.units = .si
        refreshColors()
    }
    
    func refreshColors()
    {
        view.backgroundColor = colorScheme.background
        currentTime?.textColor = colorScheme.normalText
        currentDate?.textColor = colorScheme.normalText
        trainDestinationLabel?.textColor = colorScheme.normalText
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshWeather()
        refreshTrains()
        refreshTime()
        
        Timer.every(15.seconds)
        {
            self.displayNextCity()
            self.displayNextTrainJourney()
        }
        
        Timer.every(5.minutes)
        {
            self.refreshWeather()
        }

        Timer.every(10.second)
        {
            self.refreshTime()
        }

        Timer.every(1.minutes)
        {
            self.refreshTrains()
        }
    }
    
    func refreshTime()
    {
        currentTime?.text = dateCellFormatter.string(from: Date())
        currentDate?.text = currentDayCellFormatter.string(from: Date())
    }
    
    func refreshTrains()
    {
        if userSettings.rail.getJourneys().count > 0
        {
            for journey in userSettings.rail.getJourneys()
            {
                TrainClient.getTrains(from: journey.originCRS,
                                      to: journey.destinationCRS)
                {
                    departures in
                    
                    self.departures[journey] = departures
                    if self.currentJourneyIndex == -1
                    {
                        self.displayNextTrainJourney()
                    }
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
            }
        }
    }
    
    func displayNextCity()
    {
        currentAreaIndex = (currentAreaIndex + 1) % self.areasOfInterest.count
        currentLocation = self.areasOfInterest[currentAreaIndex]
        self.displayWeatherFor(currentLocation)
    }

    func refreshWeather()
    {
        for location in areasOfInterest
        {
            ViewController.forwardGeocoding(address: location)
            { coordinates in
                self.client.getForecast(latitude: coordinates.latitude, longitude: coordinates.longitude)
                {
                    result in
                    let rootObject = result.value.0
                    self.weatherMap[location] = rootObject
                    if self.currentLocation == ""
                    {
                        self.currentLocation = location
                        self.currentAreaIndex = self.areasOfInterest.index(of: location)!
                        self.displayWeatherFor(location)

                    }
                }
            }
        }
    }
    
    func displayWeatherFor(_ location: String)
    {
        DispatchQueue.main.async {
            if let forecast = self.weatherMap[location]
            {
                self.weatherView?.displayForecast(forecast, location: location)
            }
        }
    }
    
    func displayNextTrainJourney()
    {
        if userSettings.rail.getJourneys().count != 0
        {
            currentJourneyIndex = (currentJourneyIndex + 1) % userSettings.rail.getJourneys().count

            let journey = userSettings.rail.getJourneys()[currentJourneyIndex]
            
            if let source = appSettings.stationMap[journey.originCRS],
                let destination = appSettings.stationMap[journey.destinationCRS]
            {
                let attributedSource = NSMutableAttributedString(string: source, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
                let attributedDestination = NSAttributedString(string: destination, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
                attributedSource.append(NSAttributedString(string: " → ", attributes:[NSForegroundColorAttributeName: colorScheme.alternativeText]))
                attributedSource.append(attributedDestination)
                trainDestinationLabel?.attributedText = attributedSource
            }
        }

        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if currentJourneyIndex == -1
        {
            return 0
        }
        let currentJourney = userSettings.rail.getJourneys()[currentJourneyIndex]
        return departures[currentJourney]?.trainServices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentJourney = userSettings.rail.getJourneys()[currentJourneyIndex]

        let service = departures[currentJourney]!.trainServices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell") as! TrainCell
        cell.arivalTime?.text = "Leaving at " + service.std! + " (\(Int(service.getJourneyDuration(toStationCRS: currentJourney.destinationCRS) / 60)) min)"
        cell.arivalTime?.textColor = colorScheme.normalText
        
        if service.etd == "On time" || service.etd == service.std
        {
            cell.delay?.text = "On time"
            cell.delay?.textColor = colorScheme.positiveText
        }
        else if service.etd == "Delayed" || service.etd == "Cancelled"
        {
            cell.delay?.text = service.etd
            cell.delay?.textColor = colorScheme.errorText
            cell.arivalTime?.textColor = colorScheme.errorText
        }
        else
        {
            cell.delay?.text = "(\(Int(service.delay / 60)) min)"
            cell.delay?.textColor = colorScheme.warningText
        }
        
        
        cell.backgroundColor = UIColor.clear
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            cell.preservesSuperviewLayoutMargins = false

            cell.layoutMargins = .zero
            cell.separatorInset = .zero
        }
        
        if let platform = service.platform
        {
            cell.platform?.text = "Platform \(platform)"
            cell.platform?.textColor = colorScheme.alternativeText
        }
        else
        {
            cell.platform?.textColor = colorScheme.warningText
            cell.platform?.text = "Platform unknown"
        }
        
        cell.operatorImage?.image = UIImage(named: service.operatorCode!, in: nil, compatibleWith: nil)
        
        return cell
    }
}

extension ViewController
{
    static func forwardGeocoding(address: String, completion: @escaping (CLLocationCoordinate2D) -> Void)
    {
        CLGeocoder().geocodeAddressString(address)
        { (placemarks, error) in
            if error != nil
            {
                return
            }
            if let placemarks = placemarks, placemarks.count > 0
            {
                let placemark = placemarks[0]
                let location = placemark.location
                let coordinate = location?.coordinate
                if let coordinate = coordinate
                {
                    completion(coordinate)
                }
            }
        }
    }
}

