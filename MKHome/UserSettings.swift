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
    
    fileprivate var journeys: [Journey] = []
    fileprivate var weatherCities: [String] = []

    init()
    {
        if let data = UserDefaults.standard.object(forKey: "journeys") as? Data
        {
            if let journeys = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Journey]
            {
                self.journeys = journeys
            }
        }

        if let data = UserDefaults.standard.object(forKey: "weatherCities") as? Data
        {
            if let weatherCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String]
            {
                self.weatherCities = weatherCities
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
        
        let data = NSKeyedArchiver.archivedData(withRootObject: journeys)
        UserDefaults.standard.set(data, forKey: "journeys")
    }
 
    func removeJourney(_ journey: Journey)
    {
        if let index = journeys.index(of: journey)
        {
            journeys.remove(at: index)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: journeys)
        UserDefaults.standard.set(data, forKey: "journeys")
    }

}
