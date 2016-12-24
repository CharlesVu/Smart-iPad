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
}

// Weather
extension UserSettings
{
    struct City: Hashable, Equatable
    {
        var name: String
        var coordinates: CLLocationCoordinate2D

        static func lookup(name: String, completion: @escaping (Error?, CLLocationCoordinate2D?) -> Void)
        {
            CLGeocoder().geocodeAddressString(name)
            { (placemarks, error) in
                if error != nil
                {
                    completion(error, nil)
                }
                if let placemarks = placemarks, placemarks.count > 0
                {
                    let placemark = placemarks[0]
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    if let coordinate = coordinate
                    {
                        completion(nil, coordinate)
                    }
                }
            }
        }

        var hashValue: Int
        {
            return name.hashValue
        }

        static func ==(lhs: City, rhs: City) -> Bool
        {
            return lhs.name == rhs.name
        }
    }

    class Weather
    {
        static let archiveKey = "weather.cities"
        fileprivate var cities: [City] = []

        init()
        {
            if let data = UserDefaults.standard.object(forKey: Weather.archiveKey) as? Data
            {
                if let weatherCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String]
                {
                    for cityName in weatherCities
                    {
                        City.lookup(name: cityName)
                        { (error, coordinate) in
                            if let coordinate = coordinate
                            {
                                self.cities.append(City(name: cityName, coordinates: coordinate))
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

        func addCity(_ city: String)
        {
            City.lookup(name: city)
            { (error, coordinate) in
                if let coordinate = coordinate
                {
                    self.cities.append(City(name: city, coordinates: coordinate))
                }
            }
            save()
        }

        func removeCity(_ cityName: String)
        {
            let index = cities.index { (city) -> Bool in
                return city.name == cityName
            }

            if let index = index
            {
                cities.remove(at: index)
            }

            save()
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
