//
//  TrainClasses.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import HuxleySwift

extension HuxleySwift.TrainServices {
    var delay: TimeInterval {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"

        if let normalLeavingTime = std,
            let estimatedLeavingTime = etd {
            let normalLeavingDate = formatter.date(from: normalLeavingTime)
            let estimatedLeavingDate = formatter.date(from: estimatedLeavingTime)

            return estimatedLeavingDate!.timeIntervalSince(normalLeavingDate!)
        }
        return -1
    }

    func getJourneyDuration(toStationCRS crs: String) -> TimeInterval {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"

        let arrivalCallingPoint = getCallingPoint(crs: crs)

        if let leavingTimeString = std,
            let arrivalTimeString = arrivalCallingPoint?.st {
            let leavingTime = formatter.date(from: leavingTimeString)
            let arrivalTime = formatter.date(from: arrivalTimeString)
            if let leavingTime = leavingTime {
                var duration = arrivalTime!.timeIntervalSince(leavingTime)
                if duration < 0 {
                    duration += 1.day
                }

                return duration
            }
        }
        return -1
    }

    func getCallingPoint(crs: String) -> HuxleySwift.CallingPoint? {
        for subsequentCallingPoint in subsequentCallingPoints {
            if let callingPoints = subsequentCallingPoint.callingPoint {
                for callpoint in callingPoints {
                    if callpoint.crs == crs {
                        return callpoint
                    }
                }
            }
        }

        return nil
    }
}
