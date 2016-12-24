//
//  UserSettings.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

class UserSettings
{
    static let sharedInstance = UserSettings()
    
    let weather = Weather()
    let rail = NationalRail()
}

// Weather
extension UserSettings
{
    class Weather
    {
        static let archiveKey = "weather.cities"
        fileprivate var cities: [String] = []

        init()
        {
            if let data = UserDefaults.standard.object(forKey: Weather.archiveKey) as? Data
            {
                if let weatherCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String]
                {
                    cities = weatherCities
                }
            }
        }

        func getCities() -> [String]
        {
            return cities
        }

        func addCity(_ city: String)
        {
            cities.append(city)
            save()
        }

        func removeCity(_ city: String)
        {
            if let index = cities.index(of: city)
            {
                cities.remove(at: index)
            }

            save()
        }

        fileprivate func save()
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: cities)
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
