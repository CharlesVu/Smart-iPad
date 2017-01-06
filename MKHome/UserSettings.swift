//
//  UserSettings.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import MapKit

class UserSettings
{
    static let sharedInstance = UserSettings()
    
    let weather = Weather()
    let rail = NationalRail()
    let colorScheme = Color()
}

protocol WeatherDelegate
{
    func onCityChanged()
}

// Weather
extension UserSettings
{
    class Weather
    {
        static let archiveKey = "weather.cities"
        fileprivate var cities: [City] = []
        var delegate : WeatherDelegate?

        init()
        {
            if let data = UserDefaults.standard.object(forKey: Weather.archiveKey) as? Data
            {
                if let weatherCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String]
                {
                    for cityName in weatherCities
                    {
                        City.lookupCoordinates(name: cityName)
                        { (error, coordinate) in
                            if let coordinate = coordinate
                            {
                                self.cities.append(City(name: cityName, coordinates: coordinate))
                                self.delegate?.onCityChanged()
                            }
                        }
                    }
                }
            }
        }

        func getCities() -> [City]
        {
            return cities
        }

        func addCity(_ city: City)
        {
            cities.append(city)
            save()
            delegate?.onCityChanged()
        }

        func removeCity(_ city: City)
        {
            if let index = cities.index(of: city)
            {
                cities.remove(at: index)
            }

            save()
            delegate?.onCityChanged()
        }

        fileprivate func save()
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: cities.map({ (city) -> String in
                return city.name
            }))
            UserDefaults.standard.set(data, forKey: Weather.archiveKey)
        }
    }
}

// Train Related
extension UserSettings
{
    class NationalRail
    {
        static let archiveKey = "NationalRail.journeys"

        fileprivate var journeys: [Journey] = []

        init()
        {
            if let data = UserDefaults.standard.object(forKey: NationalRail.archiveKey) as? Data
            {
                if let journeys = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Journey]
                {
                    self.journeys = journeys
                }
            }
        }

        func getJourneys() -> [Journey]
        {
            return journeys
        }

        func addJourney(_ journey: Journey)
        {
            journeys.append(journey)
            save()
        }

        func removeJourney(_ journey: Journey)
        {
            if let index = journeys.index(of: journey)
            {
                journeys.remove(at: index)
            }
            save()
        }

        fileprivate func save()
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: journeys)
            UserDefaults.standard.set(data, forKey: NationalRail.archiveKey)
        }
    }
}

extension UserSettings
{
    class Color
    {
        static let archiveKey = "Color.selected"
        static let colorChangedNotificationName = NSNotification.Name("Settings.ColorChanged")
            
        var scheme: ColorScheme = ColorScheme.solarizedDark
        {
            didSet
            {
                save()
                NotificationCenter.default.post(name: Color.colorChangedNotificationName, object: nil, userInfo: ["colorScheme": scheme])
            }
        }
        
        init()
        {
            if let colorSchemeName = UserDefaults.standard.object(forKey: Color.archiveKey) as? String
            {
                if let colorScheme = ColorScheme.allValues[colorSchemeName]
                {
                    self.scheme = colorScheme
                }
            }
        }
        
        fileprivate func save()
        {
            UserDefaults.standard.set(scheme.name, forKey: Color.archiveKey)
        }

    }
}
