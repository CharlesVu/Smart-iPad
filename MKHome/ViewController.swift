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

class ViewController: UIViewController
{
    let areasOfInterest = ["Milton Keynes, UK", "Leicester Square Station, London"]
    var currentAreaIndex = 0
    // Weather Stuff
    private let client = DarkSkyClient(apiKey: Configuration().darkSkyApiToken)
    fileprivate var weatherMap: [String: Forecast] = [:]
    fileprivate var currentLocation: String = ""
    
    @IBOutlet weak var currentWeather: SKYIconView?
    @IBOutlet weak var currentTemerature: UILabel?
    @IBOutlet weak var currentHumanDescription: UILabel?
    @IBOutlet weak var currentTime: UILabel?
    @IBOutlet weak var currentDate: UILabel?
    @IBOutlet weak var weatherTitle: UILabel?

    @IBOutlet weak var collectionView: UICollectionView?
    
    let dateCellFormatter = DateFormatter()
    let currentDayCellFormatter = DateFormatter()
    
    // Train Stuff
    fileprivate var trains: [Train.Service] = []
    @IBOutlet weak var tableView: UITableView?
    
    var trainDestination = "MKC"
    var trainSource = "EUS"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        currentDayCellFormatter.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
        
        client.units = .si
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        

        if UIDevice.current.userInterfaceIdiom == .pad
        {
            self.refreshWeather()

            Timer.every(15.seconds)
            {
                self.displayNextCity()
            }
            
            Timer.every(5.minutes)
            {
                self.refreshWeather()
            }
            
            trainDestination = "EUS"
            trainSource = "MKC"
        }
        
        self.refreshTrains()
        self.refreshTime()


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
        TrainClient().getTrains(from: trainSource, to: trainDestination)
        {
            trains in
            
            self.trains = trains
            DispatchQueue.main.async {
                self.tableView?.reloadData()
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
        let forecast = weatherMap[location]
        
        DispatchQueue.main.async {
            self.weatherTitle?.text = "Weather in \(location)"

            if let icon = forecast?.currently?.icon
            {
                self.currentWeather?.setType = icon
                self.currentWeather?.play()
                self.currentWeather?.tintColor = UIColor.solarizedBase1
            }
            self.collectionView?.reloadData()
            
            if let description = forecast?.hourly?.summary
            {
                self.currentHumanDescription?.text = description
            }
            
            if let temperature = forecast?.currently?.temperature
            {
                self.currentTemerature?.text = "\(Int(temperature))°C"
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        let forecast = weatherMap[currentLocation]

        return min(forecast?.hourly?.data.count ?? 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let forecast = weatherMap[currentLocation]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell",
                                                      for: indexPath) as! WeatherCell
        cell.backgroundColor = UIColor.clear
        if let data = forecast?.hourly?.data[indexPath.row]
        {
            cell.icon?.setType = data.icon!
            cell.icon?.tintColor = UIColor.solarizedBase1
            cell.icon?.play()
            
            if let temperature = data.temperature
            {
                cell.temperature?.text = "\(Int(temperature))°C"
            }
            let time = data.time
            cell.time?.text = dateCellFormatter.string(from: time)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.trains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let service = self.trains[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell") as! TrainCell
        cell.arivalTime?.text = "Leaving at " + service.normalLeavingTime! + " (\(Int(service.length / 60)) min)"
        cell.arivalTime?.textColor = UIColor.solarizedBase1
        
        if service.estimatedLeavingTime == service.normalLeavingTime
        {
            cell.delay?.text = "On time"
            cell.delay?.textColor = UIColor.solarizedGreen
        }
        else
        {
            if service.delay == -1
            {
                cell.delay?.text = "Delayed"
                cell.delay?.textColor = UIColor.solarizedRed
                cell.arivalTime?.textColor = UIColor.solarizedRed
            }
            else
            {
                cell.delay?.text = "(\(Int(service.delay / 60)) min)"
                cell.delay?.textColor = UIColor.solarizedOrange
            }
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
            cell.platform?.textColor = UIColor.solarizedBase1
        }
        else
        {
            cell.platform?.textColor = UIColor.solarizedOrange
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

