//
//  MockManager.swift
//  MercadoPagoServicesTests
//
//  Created by Eden Torres on 11/2/17.
//  Copyright © 2017 Mercado Pago. All rights reserved.
//

import Foundation

class MockManager: NSObject {

    internal class func getMockResponseFor(_ uri: String, method: String) throws -> Data {
        let path = Bundle(for:MockManager.self).path(forResource: "MockedResponse", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        let valueOfKey = dictPM?.value(forKey: method + uri) as! String
        let data = valueOfKey.data(using: String.Encoding.utf8)
        return data!
    }
}
