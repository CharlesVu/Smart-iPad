//
//  TrainStationPersistance.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation

public class TrainStation: Equatable, Hashable, Codable {
    public let crsCode: String
    public let stationName: String

    public init(crsCode: String, stationName: String) {
        self.crsCode = crsCode
        self.stationName = stationName
    }

    public init(realmObject: RealmTrainStation) {
        self.crsCode = realmObject.crsCode
        self.stationName = realmObject.stationName
    }

    public static func == (lhs: TrainStation, rhs: TrainStation) -> Bool {
        return lhs.crsCode == rhs.crsCode
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(crsCode)
    }
}

public extension Persistance {
    func addTrainStations(trainStation: [TrainStation]) {
        try! realm.write {
            trainStation.forEach {
                let realmObject = RealmTrainStation(trainStation: $0)
                realm.add(realmObject, update: .modified)
            }
        }
    }

    func allTrainStation() -> [TrainStation] {
        return realm.objects(RealmTrainStation.self).map { TrainStation(realmObject: $0) }
    }
}
