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
import Huxley

class ViewController: UIViewController
{
    fileprivate var colorScheme = ColorScheme.solarizedLight {
        didSet {
            self.refreshColors()
            self.tableView?.reloadData()
            self.collectionView?.reloadData()
        }
    }

    fileprivate let userSettings = UserSettings.sharedInstance
    fileprivate let appSettings = AppData.sharedInstance

    // Weather Stuff
    private let client = DarkSkyClient(apiKey: Configuration().darkSkyApiToken)
    fileprivate var weatherMap: [String: Forecast] = [:]
    fileprivate var currentLocation: String = ""
    private var currentAreaIndex = 0

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
    fileprivate var departures: [Journey: Huxley.Departures] = [:]
    fileprivate var currentJourneyIndex = -1
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var trainDestinationLabel: UILabel?
   
    
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
        currentWeather?.tintColor = colorScheme.normalText
        currentTemerature?.textColor = colorScheme.normalText
        currentHumanDescription?.textColor = colorScheme.normalText
        currentTime?.textColor = colorScheme.normalText
        currentDate?.textColor = colorScheme.normalText
        weatherTitle?.textColor = colorScheme.normalText
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
        if userSettings.getJourneys().count > 0
        {
            for journey in userSettings.getJourneys()
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
        let forecast = weatherMap[location]
        
        DispatchQueue.main.async {
            self.weatherTitle?.pushTransition(duration: 0.3)
            self.weatherTitle?.text = "Weather in \(location)"

            if let icon = forecast?.currently?.icon
            {
                self.currentWeather?.pushTransition(duration: 0.3)
                self.currentWeather?.setType = icon
                self.currentWeather?.play()
                self.currentWeather?.tintColor = self.colorScheme.normalText
            }
            self.collectionView?.reloadData()
            
            if let description = forecast?.hourly?.summary
            {
                self.currentHumanDescription?.pushTransition(duration: 0.3)
                self.currentHumanDescription?.text = description
            }
            
            if let temperature = forecast?.currently?.temperature
            {
                self.currentTemerature?.pushTransition(duration: 0.3)
                self.currentTemerature?.text = "\(Int(temperature))°C"
            }
        }
    }
    
    func displayNextTrainJourney()
    {
        if userSettings.getJourneys().count != 0
        {
            currentJourneyIndex = (currentJourneyIndex + 1) % userSettings.getJourneys().count
        }

        let journey = userSettings.getJourneys()[currentJourneyIndex]
        
        if let source = appSettings.stationMap[journey.originCRS],
            let destination = appSettings.stationMap[journey.destinationCRS]
        {
            let attributedSource = NSMutableAttributedString(string: source, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
            let attributedDestination = NSAttributedString(string: destination, attributes:[NSForegroundColorAttributeName: colorScheme.normalText])
            attributedSource.append(NSAttributedString(string: " → ", attributes:[NSForegroundColorAttributeName: colorScheme.alternativeText]))
            attributedSource.append(attributedDestination)
            trainDestinationLabel?.attributedText = attributedSource
        }
        
        self.tableView?.reloadData()
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
            if let temperature = data.temperature
            {
                cell.temperature?.text = "\(Int(temperature))°C"
                cell.temperature?.textColor = self.colorScheme.normalText
            }

            UIView.animate(withDuration: 0.3)
            {
                cell.icon?.alpha = 1
                cell.temperature?.alpha = 1
                cell.icon?.play()
            }
            
            cell.icon?.tintColor = self.colorScheme.normalText
            
            let time = data.time

            cell.time?.text = dateCellFormatter.string(from: time)
            cell.time?.textColor = self.colorScheme.alternativeText

        }
        
        return cell
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
        let currentJourney = userSettings.getJourneys()[currentJourneyIndex]
        return departures[currentJourney]?.trainServices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentJourney = userSettings.getJourneys()[currentJourneyIndex]

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

extension UIView
{
    func fadeTransition(duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFromTop
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionFromTop)
    }
    
    func pushTransition(duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionPush)
    }

}

