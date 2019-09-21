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
import Persistance
import CoreLocation

class WeatherViewController: UIViewController {
    private let client = DarkSkyClient(apiKey: Configuration.shared.darkSkyApiToken)
    fileprivate var weatherMap: [WeatherCity: Forecast] = [:]
    fileprivate var currentLocation: WeatherCity?
    private var currentAreaIndex = 0

    @IBOutlet weak var currentWeather: SKYIconView?
    @IBOutlet weak var currentTemerature: UILabel?
    @IBOutlet weak var currentHumanDescription: UILabel?
    @IBOutlet weak var weatherTitle: UILabel?
    @IBOutlet weak var weatherCollectionView: UICollectionView?

    fileprivate var forecast: Forecast?
    let dateCellFormatter = DateFormatter()

    override func awakeFromNib() {
        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        weatherCollectionView?.dataSource = self
        UserSettings.sharedInstance.weather.delegate = self
        client.units = .si
        self.view.isHidden = true
    }

    override func viewDidLoad() {
        Timer.every(15.seconds) {
            self.displayNextCity()
        }

        Timer.every(5.seconds) {
            self.refreshWeather()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshWeather()
    }

    func displayNextCity() {
        if UserSettings.sharedInstance.weather.getCities().count > 0 {
            currentAreaIndex = (currentAreaIndex + 1) % UserSettings.sharedInstance.weather.getCities().count
            currentLocation = UserSettings.sharedInstance.weather.getCities()[currentAreaIndex]
            self.displayWeatherFor(currentLocation)
        } else {
            view.isHidden = true
        }
    }

    func refreshWeather() {
        for location in UserSettings.sharedInstance.weather.getCities() {
            let coordinates = CLLocationCoordinate2D(latitude: location.latitude,
            longitude: location.longitude)
            client.getForecast(location: coordinates) {
                result in
                switch result {
                case .success(let forecast, _):
                    self.weatherMap[location] = forecast
                    if self.currentLocation == nil {
                        self.currentLocation = location
                        self.currentAreaIndex = UserSettings.sharedInstance.weather.getCities().firstIndex(of: location)!
                        self.displayWeatherFor(location)
                    }
                case .failure:
                    ()
                }
            }

        }
    }

    func displayWeatherFor(_ location: WeatherCity?) {
        DispatchQueue.main.async {
            if let location = location {
                if let forecast = self.weatherMap[location] {
                    self.view.isHidden = false
                    self.displayForecast(forecast, city: location)
                }
            }
        }
    }

    public func reloadData() {
        weatherCollectionView?.reloadData()
    }

    public func displayForecast(_ forecast: Forecast, city: WeatherCity) {
        self.forecast = forecast

        weatherTitle?.pushTransition(duration: 0.3)
        weatherTitle?.text = "Weather in \(city.name)"

        if let icon = forecast.currently?.icon {
            currentWeather?.pushTransition(duration: 0.3)
            currentWeather?.setType = icon
            currentWeather?.play()
        }
        weatherCollectionView?.reloadData()

        if let description = forecast.hourly?.summary {
            currentHumanDescription?.pushTransition(duration: 0.3)
            currentHumanDescription?.text = description
        }

        if let temperature = forecast.currently?.temperature {
            currentTemerature?.pushTransition(duration: 0.3)
            currentTemerature?.text = "\(Int(temperature))°C"
        }

        weatherCollectionView?.reloadData()
    }
}

extension WeatherViewController: WeatherDelegate {
    func onCityChanged() {
        refreshWeather()
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return min(forecast?.hourly?.data.count ?? 0, 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell",
                                                      for: indexPath) as! WeatherCell
        cell.backgroundColor = UIColor.clear

        if let data = forecast?.hourly?.data[indexPath.row] {
            cell.icon?.setType = data.icon!
            if let temperature = data.temperature {
                cell.temperature?.text = "\(Int(temperature))°C"
            }

            UIView.animate(withDuration: 0.3) {
                cell.icon?.alpha = 1
                cell.temperature?.alpha = 1
                cell.icon?.play()
            }

            let time = data.time

            cell.time?.text = dateCellFormatter.string(from: time)

        }

        return cell
    }
}
