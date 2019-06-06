//
//  TFLPersistance.swift
//  Persistance
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation

public class TFLMode {
    public let name: String
    public let lines: [TFLLine]

    init(realmObject: RealmTFLMode) {
        self.name = realmObject.name
        self.lines = realmObject.lines.map { TFLLine(realmObject: $0) }
    }

    public init(name: String, lines: [TFLLine]) {
        self.name = name
        self.lines = lines
    }
}

public class TFLLine {
    public let name: String
    public let id: String

    init(realmObject: RealmTFLLine) {
        self.id = realmObject.id
        self.name = realmObject.name
    }

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public extension Persistance {
    func addTFLMode(_ mode: TFLMode) {
        try! realm.write {
            let realmObject = RealmTFLMode(mode: mode)
            realm.add(realmObject, update: .modified)
        }
    }

    func allTFLModes() -> [TFLMode] {
        return realm.objects(RealmTFLMode.self).map { TFLMode(realmObject: $0) }
    }
}
