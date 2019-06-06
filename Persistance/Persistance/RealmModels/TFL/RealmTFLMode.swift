//
//  TFLMode.swift
//  Persistance
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class RealmTFLMode: Object {
    public dynamic var name: String! = ""
    public dynamic var lines: List<RealmTFLLine> = List()

    override public static func primaryKey() -> String? {
        return "name"
    }

    convenience init(name: String,
                     lines: List<RealmTFLLine>) {
        self.init()
        self.name = name
        self.lines = lines
    }

    convenience init(mode: TFLMode) {
        self.init()
        self.name = mode.name
        lines.append(objectsIn: mode.lines.map { RealmTFLLine(line: $0) })
    }
}
