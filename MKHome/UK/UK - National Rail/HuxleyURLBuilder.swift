//
//  HuxleyURLBuilder.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation

extension NationalRail {
    class HuxleyJourneyListURLBuilder {
        private var origin: String?
        private var destination: String?

        func setOrigin(_ origin: String) -> HuxleyJourneyListURLBuilder {
            self.origin = origin
            return self
        }

        func setDestination(_ destination: String) -> HuxleyJourneyListURLBuilder {
            self.destination = destination
            return self
        }

        func build() -> String {
            guard let origin = origin, let destination = destination else {
                assert(false, "Source or Destination not set")
                return ""
            }

            return "\(Configuration.shared.huxleyProxyEndpoint)/departures/\(origin)/to/\(destination)?accessToken=\(Configuration.shared.huxleyToken)&expand=true"
        }
    }

    struct HuxleyTrainListURLBuilder {
        func build() -> String {
            return "\(Configuration.shared.huxleyProxyEndpoint)crs/?accessToken=\(Configuration.shared.huxleyToken)"
        }
    }
}
