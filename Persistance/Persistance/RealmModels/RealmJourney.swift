//
//  Journey.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public final class RealmJourney: Object {
    public dynamic var id: String! = UUID().uuidString
    public dynamic var originCRS: String! = ""
    public dynamic var destinationCRS: String! = ""

    convenience public init(originCRS: String, destinationCRS: String) {
        self.init()
        self.originCRS = originCRS
        self.destinationCRS = destinationCRS
        self.id = originCRS + destinationCRS
    }

    override public static func primaryKey() -> String? {
        return "id"
    }

    convenience init(journey: Journey) {
        self.init()
        self.originCRS = journey.originCRS
        self.destinationCRS = journey.destinationCRS
    }
}
