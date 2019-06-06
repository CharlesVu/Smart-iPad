//
//  UserSettings.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import MapKit
import Persistance

class UserSettings {
    static let sharedInstance = UserSettings()

    let weather = Weather()
    let rail = NationalRail()
}

protocol WeatherDelegate: class {
    func onCityChanged()
}

// Weather
extension UserSettings {
    class Weather {
        fileprivate var cities: [WeatherCity] = []
        weak var delegate: WeatherDelegate?

        init() {
            cities = Persistance.shared.allWeatherCity()
        }

        func getCities() -> [WeatherCity] {
            return cities
        }

        func addCity(_ city: WeatherCity) {
            cities.append(city)
            Persistance.shared.addWeatherCity(city: city)
            delegate?.onCityChanged()
        }

        func removeCity(_ city: WeatherCity) {
            cities.removeAll(where: { $0 == city })
            Persistance.shared.removeWeatherCity(city: city)
            delegate?.onCityChanged()
        }
    }
}

// Train Related
extension UserSettings {
    class NationalRail {
        fileprivate var journeys: [Journey] = []

        init() {
            journeys = Persistance.shared.allJourney()
        }

        func getJourneys() -> [Journey] {
            return journeys
        }

        func addJourney(_ journey: Journey) {
            journeys.append(journey)
            Persistance.shared.addJourney(journey: journey)
        }

        func removeJourney(_ journey: Journey) {
            journeys.removeAll { $0 == journey }
            Persistance.shared.removeJourney(journey: journey)
        }
    }
}
