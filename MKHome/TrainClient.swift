//
//  TrainClient.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Alamofire

class TrainClient
{
    func getTrains(from: String, to: String, completion: @escaping ([Train.Service]) -> Void)
    {
        Alamofire.request("\(Configuration().huxleyProxyEndpoint)/departures/\(from)/to/\(to)?accessToken=\(Configuration().huxleyToken)&expand=true", method: .get)
            .responseJSON
            { response in
                var result: [Train.Service] = []
                
                if let json = response.result.value as? [String: Any]
                {
                    if let services = json["trainServices"] as? [[String: Any]]
                    {
                        for data in services
                        {
                            let service = Train.Service(json: data, source: from, destination: to)
                            result.append(service)
                        }
                    }
                }
                completion(result)
        }

    }
}
