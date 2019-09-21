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

public class TFLStatusDescription {
    public let mode: String
    public let name: String
    public let level: Int

    init(realmObject: RealmTFLStatusDescription) {
        self.level = realmObject.severityLevel
        self.name = realmObject.name
        self.mode = realmObject.mode
    }

    public init(mode: String, level: Int, name: String) {
        self.mode = mode
        self.level = level
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

    func addStatusDescription(_ statuses: [TFLStatusDescription]) {
        let realmStatus = statuses.map { RealmTFLStatusDescription(status: $0) }

        try! realm.write {
            for realmObject in realmStatus {
                realm.add(realmObject, update: .modified)
            }
        }
    }

    func statusDescription(`for` mode: String, level: Int) -> TFLStatusDescription? {
        realm.objects(RealmTFLStatusDescription.self).filter { (description) -> Bool in
            return description.severityLevel == level && description.mode == mode
            }.map { TFLStatusDescription(realmObject: $0) }.first
    }

    func isLineActivated(_ line: TFLLine) -> Bool {
        let preferences = userPreferences()
        return preferences.activeLines.contains { $0.id == line.id }
    }

    func activateLine(_ line: TFLLine) {
        let preferences = userPreferences()
        let line = realm.objects(RealmTFLLine.self).first { $0.id == line.id }!
        try! realm.write {
            preferences.activeLines.append(line)
        }
    }

    func disableLine(_ line: TFLLine) {
        let preferences = userPreferences()
        try! realm.write {
            if let index = preferences.activeLines.index(matching: "id == %@", line.id) {
                preferences.activeLines.remove(at: index)
            }
        }
    }
}
