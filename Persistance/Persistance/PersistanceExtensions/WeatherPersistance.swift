//
//  WeatherPersistance.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation

public struct WeatherCity: Equatable, Hashable {
    public let name: String
    public let longitude: Double
    public let latitude: Double

    init(realmObject: RealmWeatherCity) {
        self.name = realmObject.name
        self.longitude = realmObject.longitude
        self.latitude = realmObject.latitude
    }

    public init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}

public extension Persistance {
    func addWeatherCity(city: WeatherCity) {
        try! realm.write {
            let realmObject = RealmWeatherCity(city: city)
            realm.add(realmObject, update: .modified)
        }
    }

    func removeWeatherCity(city: WeatherCity) {
        try! realm.write {
            let realmObject = RealmWeatherCity(city: city)
            realm.delete(realmObject)
        }
    }

    func allWeatherCity() -> [WeatherCity] {
        return realm.objects(RealmWeatherCity.self).map { WeatherCity(realmObject: $0) }
    }
}
