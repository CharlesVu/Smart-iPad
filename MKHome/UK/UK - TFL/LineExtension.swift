//
//  LineExtension.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import TFLApiModels

extension Line: Hashable, Equatable {
    public static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs._id == rhs._id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._id)
    }
}
