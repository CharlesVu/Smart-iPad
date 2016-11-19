//
//  TrainClasses.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

class Train {}

extension Train
{
    class Station
    {
        let locationName: String
        let crs: String
        
        init? (json: [String: Any])
        {
            if let locationName = json["locationName"] as? String,
                let crs = json["crs"] as? String
            {
                self.locationName = locationName
                self.crs = crs
                return
            }
            return nil
        }
    }
    
    class Service
    {
        var normalLeavingTime: String?
        var normalArrivalTime: String?
        var estimatedLeavingTime: String?
        var estimatedArrivalTime: String?
        
        var length: TimeInterval = 0
        var platform: String?
        var delay: TimeInterval = 0
        
        var operatorCode: String?
        
        init(json: [String: Any], source: String, destination: String)
        {
            normalLeavingTime = json["std"] as? String
            
            if let etd = json["etd"] as? String, etd != "On time"
            {
                estimatedLeavingTime = etd
            }
            else
            {
                estimatedLeavingTime = normalLeavingTime
            }
            
            if let subsequentCallingPoints = json["subsequentCallingPoints"] as? [[String: Any]]
            {
                let subsequentCallingPoint = subsequentCallingPoints[0]
                if let callpoints = subsequentCallingPoint["callingPoint"] as? [[String: Any]]
                {
                    for callpoint in callpoints
                    {
                        if let crs = callpoint["crs"] as? String, crs == destination
                        {
                            normalArrivalTime = callpoint["st"] as? String
                            if let et = callpoint["et"] as? String, et != "On time"
                            {
                                estimatedArrivalTime = et
                            }
                            else
                            {
                                estimatedArrivalTime = normalArrivalTime
                            }

                        }
                    }
                }
            }
            
            if let platform = json["platform"] as? String
            {
                self.platform = platform
            }
            
            if let operatorCode = json["operatorCode"] as? String
            {
                self.operatorCode = operatorCode
            }
            
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("HH:mm")
            
            if let leavingTimeString = estimatedLeavingTime,
                let arrivalTimeString = estimatedArrivalTime
            {
                let leavingTime = formatter.date(from: leavingTimeString)
                let arrivalTime = formatter.date(from: arrivalTimeString)
                if let leavingTime = leavingTime
                {
                    length = arrivalTime!.timeIntervalSince(leavingTime)
                    if length < 0
                    {
                        length += 1.day
                    }
                }
            }
            
            if let normalLeavingTime = normalLeavingTime,
                let estimatedLeavingTime = estimatedLeavingTime
            {
                if estimatedLeavingTime == "Delayed" || estimatedLeavingTime == "Cancelled"
                {
                    delay = -1
                }
                else
                {
                    let normalLeavingTime = formatter.date(from: normalLeavingTime)
                    let estimatedLeavingTime = formatter.date(from: estimatedLeavingTime)

                    delay = estimatedLeavingTime!.timeIntervalSince(normalLeavingTime!)
                }
            }
        }
    }
}
