//
//  JourneyPersistance.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation

public struct Journey: Equatable, Hashable {
    public let originCRS: String
    public let destinationCRS: String

    init(realmObject: RealmJourney) {
        self.originCRS = realmObject.originCRS
        self.destinationCRS = realmObject.destinationCRS
    }

    public init(originCRS: String, destinationCRS: String) {
        self.originCRS = originCRS
        self.destinationCRS = destinationCRS
    }
}

public extension Persistance {
    func addJourney(journey: Journey) {
        try! realm.write {
            let realmObject = RealmJourney(journey: journey)
            realm.add(realmObject, update: .modified)
        }
    }

    func removeJourney(journey: Journey) {
        try! realm.write {
            let realmObject = RealmJourney(journey: journey)
            realm.delete(realmObject)
        }
    }

    func allJourney() -> [Journey] {
        return realm.objects(RealmJourney.self).map { Journey(realmObject: $0) }
    }
}
