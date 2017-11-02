//
//  MercadoPagoServicesTests.swift
//  MercadoPagoServicesTests
//
//  Created by Eden Torres on 10/24/17.
//  Copyright © 2017 Mercado Pago. All rights reserved.
//

import XCTest

class MercadoPagoServicesTests: XCTestCase {

    func testWhenPaymentsResponseStatusIsProcessingThenMapResponseToPaymentInProcess() {
        let payerDict: NSMutableDictionary = NSMutableDictionary()
        payerDict.setValue("android-was-here@gmail.com", forKey: "email")
        let paymentBodyDict: NSMutableDictionary = NSMutableDictionary()
        paymentBodyDict.setValue(payerDict, forKey: "payer")
        let mercadoPagoServices = MercadoPagoServices(merchantPublicKey: "PK_MLA")
        mercadoPagoServices.createPayment(url: "http://api.mercadopago.com", uri: "/v1/checkout/payments?public_key=PK-PROCESSING-TEST&payment_method_id=visa", transactionId: nil, paymentData: paymentBodyDict, callback: { (payment: PXPayment) -> Void in
            XCTAssertEqual(payment.status, PXPayment.Status.IN_PROCESS)
        }, failure: { (_: NSError) -> Void in
            XCTFail()
        })
    }

}
