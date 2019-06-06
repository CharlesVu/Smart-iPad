//
//  RealmTFLLine.swift
//  Persistance
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class RealmTFLLine: Object {
    public dynamic var name: String! = ""
    public dynamic var id: String! = ""

    override public static func primaryKey() -> String? {
        return "id"
    }

    convenience init(id: String,
                     name: String) {
        self.init()
        self.name = name
        self.id = id
    }

    convenience init(line: TFLLine) {
        self.init()
        self.name = line.name
        self.id = line.id
    }
}
