//
//  TrainClient.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import Alamofire
import Huxley

class TrainClient
{
    static func getTrains(from: String, to: String, completion: @escaping (Departures) -> Void)
    {
        Alamofire.request("\(Configuration().huxleyProxyEndpoint)/departures/\(from)/to/\(to)?accessToken=\(Configuration().huxleyToken)&expand=true", method: .get)
            .responseJSON
            { response in
                if let json = response.result.value as? [String: Any]
                {
                    let departures = Huxley.Departures(from: json)
                    completion(departures)
                }
        }
    }
    
    static func getTrainsNames(completion: @escaping ([String:String]) -> Void)
    {
        Alamofire.request("\(Configuration().huxleyProxyEndpoint)crs/?accessToken=\(Configuration().huxleyToken)", method: .get)
            .responseJSON
            { response in
                if let json = response.result.value as? [[String: String]]
                {
                    let crsList = Huxley.CRSList(from: json)
                    completion(crsList.crsToName)
                }
        }
    }
}
