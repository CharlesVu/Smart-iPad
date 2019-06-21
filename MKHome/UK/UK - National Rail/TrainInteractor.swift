//
//  TrainInteractor.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Alamofire
import HuxleySwift
import Persistance
import os.log

extension NationalRail {
    struct TrainInteractor {
        func getTrains(from: String, to: String, completion: @escaping (Departures) -> Void) {
            let urlString = HuxleyJourneyListURLBuilder()
                .setOrigin(from)
                .setDestination(to)
                .build()

            Alamofire.request(urlString, method: .get)
                .response { response in
                    if let data = response.data {
                        do {
                            let departures = try JSONDecoder().decode(Departures.self, from: data)
                            completion(departures)
                        } catch let error {
                            os_log("❤️ %@", error.localizedDescription)
                        }
                    }
            }
        }

        func getTrainsNames(completion: @escaping ([TrainStation]) -> Void) {
            let urlString = HuxleyTrainListURLBuilder()
                .build()

            Alamofire.request(urlString, method: .get)
                .response { response in
                if let data = response.data {
                    do {
                        let departures = try JSONDecoder().decode([TrainStation].self, from: data)
                        completion(departures)
                    } catch let error {
                        os_log("❤️ %@", error.localizedDescription)
                    }
                }
            }
        }
    }
}
