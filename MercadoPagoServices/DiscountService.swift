//
//  DiscountServices.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 12/26/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServices

open class DiscountService: MercadoPagoService {

    var URI: String


    init (baseURL: String, URI: String) {
        self.URI = URI
        super.init()
        self.baseURL = baseURL
    }

    open func getDiscount(publicKey: String, amount: Double, code: String? = nil, payerEmail: String?, additionalInfo: String? = nil, success: @escaping (_ discount: PXDiscount?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        var params = "public_key=" + publicKey + "&transaction_amount=" + String(amount)

        if !String.isNullOrEmpty(payerEmail) {
            params += "&payer_email=" + payerEmail!
        }

        if let couponCode = code {
            params = params + "&coupon_code=" + String(couponCode).trimSpaces()
        }

        if !String.isNullOrEmpty(additionalInfo) {
            params += "&" + additionalInfo!
        }

        self.request(uri: self.URI, params: params, body: nil, method: "GET", cache: false, success: { (data) -> Void in
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)

            if let discount = jsonResult as? NSDictionary {
                if let error = discount["error"] {
                    failure(NSError(domain: "mercadopago.sdk.DiscountService.getDiscount", code: PXApitUtil.ERROR_API_CODE, userInfo: [NSLocalizedDescriptionKey: error]))
                } else {
                    let discount = try! PXDiscount.fromJSON(data: data)
                    success(discount)
                }
            }

        }, failure: { (error) -> Void in
            failure(NSError(domain: "mercadopago.sdk.DiscountService.getDiscount", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "Verifique su conexión a internet e intente nuevamente"]))
        })
    }
}
