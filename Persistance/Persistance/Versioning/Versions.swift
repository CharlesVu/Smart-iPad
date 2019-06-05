//
//  Versions.swift
//  Persistance
//
//  Created by Charles Vu on 05/06/2019.
//  Copyright © 2019 Charles Vu. All rights reserved.
//

import Foundation

struct Version {
    static var current: UInt64 {
        return preRelease
    }

    static let preRelease: UInt64 = 0
}
