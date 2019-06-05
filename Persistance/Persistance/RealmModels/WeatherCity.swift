//
//  WeatherCity.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class RealmWeatherCity: Object {
    public dynamic var name: String! = ""
    public dynamic var longitude: Double! = 0
    public dynamic var latitude: Double! = 0

    override public static func primaryKey() -> String? {
        return "name"
    }

    convenience init(name: String,
                    longitude: Double,
                    latitude: Double) {
        self.init()
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }

    convenience init(city: WeatherCity) {
        self.init()
        self.name = city.name
        self.longitude = city.longitude
        self.latitude = city.latitude
    }
}
