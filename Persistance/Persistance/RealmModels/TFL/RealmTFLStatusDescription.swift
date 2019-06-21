//
//  RealmTFLStatusDescription.swift
//  Persistance
//
//  Created by Charles Vu on 21/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RealmTFLStatusDescription: Object {
    public dynamic var name: String! = ""
    public dynamic var severityLevel = 0
    public dynamic var mode: String! = ""
    public dynamic var id: String! = UUID().uuidString

    override public static func primaryKey() -> String? {
        return "id"
    }

    convenience init(mode: String,
                     level: Int,
                     name: String) {
        self.init()
        self.name = name
        self.severityLevel = level
        self.mode = mode
        self.id = "\(mode)-\(level)"
    }

    convenience init(status: TFLStatusDescription) {
        self.init()
        self.name = status.name
        self.severityLevel = status.level
        self.mode = status.mode
        self.id = "\(status.mode)-\(status.level)"
    }
}
