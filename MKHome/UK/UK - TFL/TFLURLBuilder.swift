//
//  TFLURLBuilder.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import TFLApiModels

private extension String {
    func appendCredentials() -> String {
        return self + "?app_id=\(Configuration.shared.tflApplicationID)&app_key=\(Configuration.shared.tflApiKey)"
    }
}

extension TFL {
    static let baseURL = "https://api.tfl.gov.uk/"

    class ModeStatusURLBuilder {
        private var mode: Mode!

        func setMode(mode: Mode) -> ModeStatusURLBuilder {
            self.mode = mode
            return self
        }

        func build() -> String {
            return "\(baseURL)Line/Mode/\(mode.rawValue)/Status".appendCredentials()
        }
    }

    class LinesURLBuilder {
        private var mode: Mode!

        func setMode(mode: Mode) -> LinesURLBuilder {
            self.mode = mode
            return self
        }

        func build() -> String {
            return "\(baseURL)Line/Mode/\(mode.rawValue)".appendCredentials()
        }
    }

    class StatusDescriptionURLBuilder {
        private var mode: Mode!

        func build() -> String {
            return "\(baseURL)Line/Meta/Severity".appendCredentials()
        }
    }

}
