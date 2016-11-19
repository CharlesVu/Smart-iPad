//
//  Date.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

public class Configuration
{
    public var darkSkyApiToken: String = ""
    public var huxleyProxyEndpoint: String = ""
    public var huxleyToken: String = ""

    init()
    {
        do
        {
            if let path = Bundle.main.path(forResource: "config", ofType: "plist")
            {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]
                darkSkyApiToken = (plist?["darkSkyApiToken"])!
                huxleyProxyEndpoint = (plist?["huxleyProxyEndpoint"])!
                huxleyToken = (plist?["huxleyToken"])!
            }
        }
        catch
        {
        }
    }
}
