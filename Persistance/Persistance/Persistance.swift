//
//  Persistance.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import RealmSwift
import os.log

protocol Migrating {
    var schemaVersion: UInt64 { get }
    func migrate(from oldSchemaVersion: UInt64, with migration: RealmSwift.Migration)
}

public class Persistance {
    public static var shared = Persistance()
    lazy var realm: Realm = createRealm()

    private init() { }

    private static func localDocumentPath(for fileName: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
    }

    static internal func reduceMigrationBlock(migrators: [Migrating]) -> MigrationBlock {
        let migrationBlock: RealmSwift.MigrationBlock = { migration, oldSchemaVersion in
            // migration stuff can go here!
            migrators.sorted { $0.schemaVersion < $1.schemaVersion }.forEach {
                if oldSchemaVersion < $0.schemaVersion {
                    $0.migrate(from: oldSchemaVersion, with: migration)
                }
            }
        }
        return migrationBlock
    }

    static private func realmConfiguration(migrationBlock: MigrationBlock) -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.fileURL = localDocumentPath(for: "default.realm")

        os_log("💙 Realm Location: %@", configuration.fileURL!.absoluteString)
        configuration.schemaVersion = Version.current
        return configuration
    }

    private func createRealm() -> Realm! {
        let migrations = Persistance.reduceMigrationBlock(migrators: Migrations.allMigrations())
        return try! Realm(configuration: Persistance.realmConfiguration(migrationBlock: migrations))
    }

    internal func userPreferences() -> RealmUserPreferences {
        guard let preferences = realm.objects(RealmUserPreferences.self).first else {
            let newPreferences = RealmUserPreferences()
            try! realm.write {
                realm.add(newPreferences)
            }
            return newPreferences
        }
        return preferences
    }

}
