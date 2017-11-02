//
//  MercadoPagoService.swift
//  MercadoPagoServicesTests
//
//  Created by Eden Torres on 11/2/17.
//  Copyright © 2017 Mercado Pago. All rights reserved.
//
import Foundation

open class MercadoPagoService: NSObject {

    let MP_DEFAULT_TIME_OUT = 15.0

    open static var MP_TEST_ENV = "/beta"
    open static var MP_PROD_ENV = "/v1"
    open static var MP_SELECTED_ENV = MP_PROD_ENV

    open static var API_VERSION = "1.4.X"
    open static let MP_API_BASE_URL_PROD: String =  "https://api.mercadopago.com"
    open static let MP_API_BASE_URL: String =  MP_API_BASE_URL_PROD

    open static var MP_ENVIROMENT = MP_SELECTED_ENV  + "/checkout"
    open static let MP_OP_ENVIROMENT = "/v1"
    open static let PAYMENT_METHODS = "/payment_methods"
    open static let INSTALLMENTS = "\(PAYMENT_METHODS)/installments"
    open static let CARD_TOKEN = "/card_tokens"
    open static let CARD_ISSSUERS = "\(PAYMENT_METHODS)/card_issuers"
    open static let PAYMENTS = "/payments"
    open static let MP_CREATE_TOKEN_URI = MP_OP_ENVIROMENT + CARD_TOKEN
    open static let MP_PAYMENT_METHODS_URI = MP_OP_ENVIROMENT + PAYMENT_METHODS
    open static var MP_INSTALLMENTS_URI = MP_OP_ENVIROMENT + INSTALLMENTS
    open static var MP_ISSUERS_URI = MP_OP_ENVIROMENT + CARD_ISSSUERS
    open static let MP_IDENTIFICATION_URI = "/identification_types"
    open static let MP_PROMOS_URI = MP_OP_ENVIROMENT + PAYMENT_METHODS + "/deals"
    open static let MP_SEARCH_PAYMENTS_URI = MP_ENVIROMENT + PAYMENT_METHODS + "/search/options"
    open static let MP_INSTRUCTIONS_URI = MP_ENVIROMENT + PAYMENTS + "/${payment_id}/results"
    open static let MP_PREFERENCE_URI = MP_ENVIROMENT + "/preferences/"
    open static let MP_DISCOUNT_URI =  "/discount_campaigns/"
    open static let MP_CUSTOMER_URI = "/customers?preference_id="
    open static let MP_PAYMENTS_URI = MP_ENVIROMENT + PAYMENTS

    var baseURL: String!

    init (baseURL: String) {
        super.init()
        self.baseURL = baseURL
    }

    override init () {
        super.init()
    }

    public func request(uri: String, params: String?, body: String?, method: String, headers: [String:String]? = nil, cache: Bool = true, success: @escaping (_ data: Data) -> Void,
                        failure: ((_ error: NSError) -> Void)?) {

        var finalUri = uri
        if params != nil {
            finalUri = finalUri + "?" + params!
        }

        if method == "POST" {

            do {
                let jsonResponse = try MockManager.getMockResponseFor(finalUri, method: method)

                if jsonResponse != nil {
                    success(jsonResponse)
                } else {
                    failure!(NSError(domain: uri, code: 400, userInfo: nil))
                }
            } catch {
                failure!(NSError(domain: uri, code: 400, userInfo: nil))
            }
        }
    }
}
