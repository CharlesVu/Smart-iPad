//
//  TFLCacher.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import Persistance
import TFLApiModels

extension TFLStatusDescription {
    convenience init(_ status: StatusSeverity) {
        self.init(mode: status.modeName!,
                  level: status.severityLevel!,
                  name: status._description!)
    }
}

extension TFL {
    class TFLCacher {
        func cacheLines() {
            let interactor = TFLIntetactor()

            for mode in Mode.allCases {
                interactor.getLines(mode: mode) { lines in
                    let mode = TFLMode(name: mode.rawValue, lines: lines.map { TFLLine(id: $0._id!, name: $0.name!) })
                    Persistance.shared.addTFLMode(mode)
                }
            }
        }

        func cacheStatusDescription() {
            let interactor = TFLIntetactor()

            interactor.getStatusDescription { statusDescriptions in
                Persistance.shared.addStatusDescription(statusDescriptions.map { TFLStatusDescription($0)})
            }
        }

        func cacheStatus() {
            let interactor = TFLIntetactor()

            for mode in Mode.allCases {
                interactor.getLineStatus(mode: mode) { lines in
                    let mode = TFLMode(name: mode.rawValue, lines: lines.map { TFLLine(id: $0._id!, name: $0.name!) })
//                    Persistance.shared.addTFLMode(mode)
                }
            }
        }

    }
}
