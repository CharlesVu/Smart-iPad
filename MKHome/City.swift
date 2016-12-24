//
//  City.swift
//  MKHome
//
//  Created by Charles Vu on 24/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import MapKit

struct City: Hashable, Equatable
{
    var name: String
    var coordinates: CLLocationCoordinate2D

    static func lookupCoordinates(name: String,
                                  completion: @escaping (Error?, CLLocationCoordinate2D?) -> Void)
    {
        CLGeocoder().geocodeAddressString(name)
        { (placemarks, error) in
            if error != nil
            {
                completion(error, nil)
                return
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
