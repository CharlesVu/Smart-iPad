//
//  AppData.swift
//  MKHome
//
//  Created by charles on 20/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Persistance

class AppData {
    static let sharedInstance = AppData()

    private(set) var stationMap: [String: TrainStation] = [:]
    private(set) var stationList: [TrainStation] = []

    private init() {
        stationList = Persistance.shared.allTrainStation()
        populateMap()
        if stationList.count == 0 {
            TrainClient.getTrainsNames { stations in
                Persistance.shared.addTrainStations(trainStation: stations)
                self.stationList = stations
                self.populateMap()
            }
        }
    }

    func populateMap() {
        stationMap.removeAll()

        for station in stationList {
            stationMap[station.crsCode] = station
        }

        stationList.sort { (e1, e2) -> Bool in
            return e1.stationName < e2.stationName
        }
    }
}
