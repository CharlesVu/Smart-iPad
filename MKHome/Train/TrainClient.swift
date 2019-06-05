//
//  TrainClient.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Alamofire
import HuxleySwift
import Persistance

class TrainClient {
    static func getTrains(from: String, to: String, completion: @escaping (Departures) -> Void) {        Alamofire.request("\(Configuration().huxleyProxyEndpoint)/departures/\(from)/to/\(to)?accessToken=\(Configuration().huxleyToken)&expand=true", method: .get)
            .response { response in
                if let data = response.data {
                    do {
                        let departures = try JSONDecoder().decode(Departures.self, from: data)
                        completion(departures)
                    } catch let error {
                        print(error)
                    }
                }
        }
    }

    static func getTrainsNames(completion: @escaping ([TrainStation]) -> Void) {
        Alamofire.request("\(Configuration().huxleyProxyEndpoint)crs/?accessToken=\(Configuration().huxleyToken)", method: .get).responseJSON { response in
                if let json = response.result.value as? [[String: String]] {
                    let crsList = CRSList(from: json)
                    let result = crsList.crsToName.compactMap { (keyPair) -> TrainStation in
                        let (key, value) = keyPair
                        return TrainStation(crsCode: key, stationName: value)
                    }
                    completion(result)
                }
        }
    }
}
