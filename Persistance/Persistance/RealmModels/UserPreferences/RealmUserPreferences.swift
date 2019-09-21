//
//  RealmUserPreferences.swift
//  Persistance
//
//  Created by Charles Vu on 17/08/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserPreferences: Object {
    public dynamic var activeLines: List<RealmTFLLine> = List()
    @objc public dynamic var id: String = UUID().uuidString

    override public static func primaryKey() -> String? {
        return "id"
    }
}
