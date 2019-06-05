//
//  RealmTrainStation.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public final class RealmTrainStation: Object {
    public dynamic var crsCode: String! = ""
    public dynamic var stationName: String! = ""

    convenience public init(crsCode: String, stationName: String) {
        self.init()
        self.crsCode = crsCode
        self.stationName = stationName
    }

    override public static func primaryKey() -> String? {
        return "crsCode"
    }

    convenience init(trainStation: TrainStation) {
        self.init()
        self.crsCode = trainStation.crsCode
        self.stationName = trainStation.stationName
    }
}

