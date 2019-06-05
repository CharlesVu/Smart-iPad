//
//  MigrationTemplate.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

public class AccountStateMigrator: Migrating {

    var schemaVersion: UInt64 {
        return Version.preRelease
    }

    func migrate(from oldSchemaVersion: UInt64, with migration: Migration) {
//        migration.renameProperty(onType: <#T##String#>, from: <#T##String#>, to: <#T##String#>)
//        migration.enumerateObjects(ofType: <#T##String#>, <#T##block: (MigrationObject?, MigrationObject?) -> Void##(MigrationObject?, MigrationObject?) -> Void#>)
    }
}
