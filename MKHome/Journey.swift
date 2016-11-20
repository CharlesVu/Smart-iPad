//
//  Journey.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

final class Journey: NSObject, NSCoding
{
    let originCRS: String
    let destinationCRS: String
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(originCRS, forKey: "originCRS")
        aCoder.encode(destinationCRS, forKey: "destinationCRS")
    }
    
    public init?(coder aDecoder: NSCoder)
    {
        guard let originCRS = aDecoder.decodeObject(forKey: "originCRS") as? String,
            let destinationCRS = aDecoder.decodeObject(forKey: "destinationCRS") as? String else
        {
            return nil
        }
        
        self.originCRS = originCRS
        self.destinationCRS = destinationCRS
    }
    
    public init(originCRS: String, destinationCRS: String)
    {
        self.originCRS = originCRS
        self.destinationCRS = destinationCRS
    }
}

