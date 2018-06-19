//
//  MercadoPagoService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 5/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

open class MercadoPagoService: NSObject {

    let default_time_out = 15.0
    let number_of_retries: Int = 2

    var baseURL: String!

    init (baseURL: String) {
        super.init()
        self.baseURL = baseURL
    }

    public func request(uri: String, params: String?, body: String?, method: String, headers: [String:String]? = nil, cache: Bool = true, success: @escaping (_ data: Data) -> Void,
                        failure: ((_ error: NSError) -> Void)?) {

        let url = baseURL + uri
        var requesturl = url
        if !String.isNullOrEmpty(params) {
            requesturl += "?" + params!
        }

        let finalURL: NSURL = NSURL(string: requesturl)!
        let request: NSMutableURLRequest
        if cache {
            request  = NSMutableURLRequest(url: finalURL as URL,
                                           cachePolicy: .returnCacheDataElseLoad, timeoutInterval: default_time_out)
        } else {
            request = NSMutableURLRequest(url: finalURL as URL,
                                          cachePolicy: .useProtocolCachePolicy, timeoutInterval: default_time_out)
        }

        #if DEBUG
            print("\n--REQUEST_URL: \(finalURL)")
        #endif

        request.url = finalURL as URL
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers !=  nil && headers!.count > 0 {
            for header in headers! {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let body = body {
            #if DEBUG
                print("--REQUEST_BODY: \(body as NSString)")
            #endif
            request.httpBody = body.data(using: String.Encoding.utf8)
        }

        taskWithRetry(number_of_retries, asyncTask: { (success, failure) in
            self.executeAsyncCall(request: request as URLRequest, success: success, failure: failure)
        }, success: { (responseData) in
            success(responseData)
        }, failure: { (error) in
            failure?(error as NSError)
        })
    }

    final private func executeAsyncCall(request: URLRequest, success: @escaping (_ data: Data) -> Void,
                                        failure: ((_ error: NSError) -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { (response: URLResponse?, data: Data?, error: Error?) in

            if let remoteData = data, error == nil {
                if let decodedData = String(data: remoteData, encoding: String.Encoding.utf8) as NSString? {
                    #if DEBUG
                        print("--REQUEST_RESPONSE: \(decodedData)\n")
                    #endif
                    success(remoteData)
                } else {
                    let nsError: NSError = NSError(domain: "com.mercadopago.sdk", code: NSURLErrorCannotDecodeContentData, userInfo: nil)
                    failure?(nsError)
                }
            } else {
                guard let cError = error  else {
                    let nsError: NSError = NSError(domain: "com.mercadopago.sdk", code: NSURLErrorUnknown, userInfo: nil)
                    failure?(nsError)
                    return
                }
                failure?(cError as NSError)
            }
        }
    }
}

//MARK: - Generic retry
extension MercadoPagoService {
    final private func taskWithRetry<T>(_ numberOfRetries: Int, asyncTask: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (Error) -> Void) -> Void, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        asyncTask({ (obj) in
            success(obj)
        }) { (error) in
            #if DEBUG
                print("--Error_Retry_intent \(numberOfRetries)")
            #endif
            if numberOfRetries > 1 {
                self.taskWithRetry(numberOfRetries - 1, asyncTask: asyncTask, success: success, failure: failure)
            } else {
                failure(error)
            }
        }
    }
}
