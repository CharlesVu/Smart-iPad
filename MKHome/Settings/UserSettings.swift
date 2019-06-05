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
    let colorScheme = Color()
}

protocol WeatherDelegate {
    func onCityChanged()
}

// Weather
extension UserSettings {
    class Weather {
        fileprivate var cities: [WeatherCity] = []
        var delegate: WeatherDelegate?

        init() {
            cities = Persistance.shared.allWeatherCity()
        }

        func getCities() -> [WeatherCity] {
            return cities
        }

        func addCity(_ city: WeatherCity) {
            Persistance.shared.addWeatherCity(city: city)
            delegate?.onCityChanged()
        }

        func removeCity(_ city: WeatherCity) {
            Persistance.shared.removeWeatherCity(city: city)
            delegate?.onCityChanged()
        }
    }
}

// Train Related
extension UserSettings {
    class NationalRail {
        static let archiveKey = "NationalRail.journeys"

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

extension UserSettings {
    class Color {
        static let archiveKey = "Color.selected"
        static let colorChangedNotificationName = NSNotification.Name("Settings.ColorChanged")

        var scheme: ColorScheme = ColorScheme.solarizedDark {
            didSet {
                save()
                NotificationCenter.default.post(name: Color.colorChangedNotificationName, object: nil, userInfo: ["colorScheme": scheme])
            }
        }

        init() {
            if let colorSchemeName = UserDefaults.standard.object(forKey: Color.archiveKey) as? String {
                if let colorScheme = ColorScheme.allValues[colorSchemeName] {
                    self.scheme = colorScheme
                }
            }
        }

        fileprivate func save() {
            UserDefaults.standard.set(scheme.name, forKey: Color.archiveKey)
        }

    }
}
