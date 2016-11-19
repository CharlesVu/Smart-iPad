//
//  TrainClasses.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Huxley

extension Huxley.TrainServices
{
    var delay: TimeInterval {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        
        if let normalLeavingTime = std,
            let estimatedLeavingTime = etd
        {
            let normalLeavingTime = formatter.date(from: normalLeavingTime)
            let estimatedLeavingTime = formatter.date(from: estimatedLeavingTime)
            
            return estimatedLeavingTime!.timeIntervalSince(normalLeavingTime!)
        }
        return -1
    }
    
    func getJourneyDuration(toStationCRS crs: String) -> TimeInterval
    {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        
        let arrivalCallingPoint = getCallingPoint(crs: crs)
        
        if let leavingTimeString = std,
            let arrivalTimeString = arrivalCallingPoint?.st
        {
            let leavingTime = formatter.date(from: leavingTimeString)
            let arrivalTime = formatter.date(from: arrivalTimeString)
            if let leavingTime = leavingTime
            {
                var duration = arrivalTime!.timeIntervalSince(leavingTime)
                if duration < 0
                {
                    duration += 1.day
                }
                
                return duration
            }
        }
        return -1
    }
    
    func getCallingPoint(crs: String) -> Huxley.CallingPoint?
    {
        for subsequentCallingPoint in subsequentCallingPoints
        {
            for callpoint in subsequentCallingPoint.callingPoints
            {
                if callpoint.crs == crs
                {
                    return callpoint
                }
            }
        }
    
        return nil
    }
}
