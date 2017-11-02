//
//  PXvendorSpecificAttributes.swift
//  MercadoPagoServices
//
//  Created by Eden Torres on 10/27/17.
//  Copyright © 2017 Mercado Pago. All rights reserved.
//

import Foundation
open class PXvendorSpecificAttributes: NSObject, Codable {

    open func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    open func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }

    open class func fromJSON(data: Data) throws -> PXvendorSpecificAttributes {
        return try JSONDecoder().decode(PXvendorSpecificAttributes.self, from: data)
    }
}

