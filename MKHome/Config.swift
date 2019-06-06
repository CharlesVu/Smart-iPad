//
//  Date.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

public class Configuration {
    static var shared = Configuration()

    private (set) public var darkSkyApiToken: String = ""
    private (set)  var huxleyProxyEndpoint: String = ""
    private (set)  var huxleyToken: String = ""
    private (set)  var tflApplicationID: String = ""
    private (set)  var tflApiKey: String = ""

    private init() {
        do {
            if let path = Bundle.main.path(forResource: "config", ofType: "plist") {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]
                darkSkyApiToken = (plist?["darkSkyApiToken"])!
                huxleyProxyEndpoint = (plist?["huxleyProxyEndpoint"])!
                huxleyToken = (plist?["huxleyToken"])!
                tflApplicationID = (plist?["tfApplicationID"])!
                tflApiKey = (plist?["tflApiKey"])!
            }
        } catch let error {
            assert(false, "\(error)")
        }
    }
}
