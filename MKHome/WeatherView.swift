//
//  WeatherView.swift
//  MKHome
//
//  Created by Charles Vu on 23/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit
import ForecastIO

class WeatherView: UIView
{
    private let client = DarkSkyClient(apiKey: Configuration().darkSkyApiToken)
    fileprivate var weatherMap: [UserSettings.City: Forecast] = [:]
    fileprivate var currentLocation: UserSettings.City?
    private var currentAreaIndex = 0

    @IBOutlet weak var currentWeather: SKYIconView?
    @IBOutlet weak var currentTemerature: UILabel?
    @IBOutlet weak var currentHumanDescription: UILabel?
    @IBOutlet weak var weatherTitle: UILabel?
    @IBOutlet weak var weatherCollectionView: UICollectionView?

    fileprivate var forecast: Forecast?
    let dateCellFormatter = DateFormatter()

    public var colorScheme: ColorScheme = ColorScheme.solarizedDark {
        didSet
        {
            currentWeather?.tintColor = colorScheme.normalText
            currentTemerature?.textColor = colorScheme.normalText
            currentHumanDescription?.textColor = colorScheme.normalText
            weatherTitle?.textColor = colorScheme.normalText
            weatherCollectionView?.reloadData()
        }
    }

    override func awakeFromNib()
    {
        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        weatherCollectionView?.dataSource = self
        client.units = .si
    }

    override func willMove(toSuperview newSuperview: UIView?)
    {
        if newSuperview != nil
        {
            refreshWeather()
        }

    }
    override func didMoveToSuperview()
    {
        super.didMoveToSuperview()

        Timer.every(15.seconds)
        {
            self.displayNextCity()
        }

        Timer.every(5.minutes)
        {
            self.refreshWeather()
        }
    }

    func displayNextCity()
    {
        if UserSettings.sharedInstance.weather.getCities().count > 1
        {
            currentAreaIndex = (currentAreaIndex + 1) % UserSettings.sharedInstance.weather.getCities().count
            currentLocation = UserSettings.sharedInstance.weather.getCities()[currentAreaIndex]
            self.displayWeatherFor(currentLocation)
        }
    }

    func refreshWeather()
    {
        for location in UserSettings.sharedInstance.weather.getCities()
        {
            self.client.getForecast(latitude: location.coordinates.latitude,
                                    longitude: location.coordinates.longitude)
            {
                result in
                let rootObject = result.value.0
                self.weatherMap[location] = rootObject
                if self.currentLocation == nil
                {
                    self.currentLocation = location
                    self.currentAreaIndex = UserSettings.sharedInstance.weather.getCities().index(of: location)!
                    self.displayWeatherFor(location)

                }
            }

        }
    }

    func displayWeatherFor(_ location: UserSettings.City?)
    {
        DispatchQueue.main.async {
            if let location = location
            {
                if let forecast = self.weatherMap[location]
                {
                    self.displayForecast(forecast, city: location)
                }
            }
        }
    }
    
    public func reloadData()
    {
        weatherCollectionView?.reloadData()
    }

    public func displayForecast(_ forecast: Forecast, city: UserSettings.City)
    {
        self.forecast = forecast

        weatherTitle?.pushTransition(duration: 0.3)
        weatherTitle?.text = "Weather in \(city.name)"

        if let icon = forecast.currently?.icon
        {
            currentWeather?.pushTransition(duration: 0.3)
            currentWeather?.setType = icon
            currentWeather?.play()
            currentWeather?.tintColor = colorScheme.normalText
        }
        weatherCollectionView?.reloadData()

        if let description = forecast.hourly?.summary
        {
            currentHumanDescription?.pushTransition(duration: 0.3)
            currentHumanDescription?.text = description
        }

        if let temperature = forecast.currently?.temperature
        {
            currentTemerature?.pushTransition(duration: 0.3)
            currentTemerature?.text = "\(Int(temperature))°C"
        }

        weatherCollectionView?.reloadData()
    }
}

extension WeatherView: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return min(forecast?.hourly?.data.count ?? 0, 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

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
