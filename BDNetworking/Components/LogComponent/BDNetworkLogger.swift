//
//  BDNetworkLogger.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/19.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation
class BDNetworkLogger: NSObject {

    static let sharedInstance = BDNetworkLogger()
    lazy var configParams = BDLoggerConfiguration()
    override init() {
        super.init()
//        configParams.configWithAppType(appType: .xxx)
    }
    
    
    func logDebugInfo(
        request: URLRequest,
        relativeUrl: String?,
        service: BDService,
        requestParams: [String: Any]?)
        -> Void {
            
            #if DEBUG
                let isOnline = service.child!.isOnline
                var logString = "\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"
                logString.append("API Name:\t\t\t\(relativeUrl ?? "N/A")\n")
                logString.append("HTTPMethod:\t\t\t\(request.httpMethod ?? "N/A")\n")
                logString.append("API Verison:\t\t\t\(service.apiVersion)\n")
                logString.append("Status:\t\t\t\(isOnline ? "online":"offline")\n")
                logString.append("Public Key:\t\t\t\(service.publicKey)\n")
                logString.append("Private Key:\t\t\t\(service.privateKey)\n")
                logString.append("Params:\n\t\t\t\(String(describing: requestParams))\n")
                
                logString.append("URL:\t\t\t\(request.url?.absoluteString ?? "N/A")\n")
                logString.append("Header Filds:\n\t\t\t\(String(describing: request.allHTTPHeaderFields))\n")
                logString.append("Body:\n\t\t\(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "N/A")\n")
            logString.append("\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n")
                NSLog(logString)
            #endif
    }
    
    func logDebugInfo(
        response: BDDataResponse<Any>,
        error: Error?)
        -> Void {
            #if DEBUG
                let shouldLogError = error == nil ? true : false
                var logString = "\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"
                logString.append("Status Code:\t\t\t\(String(describing: response.response?.statusCode))\n")
                logString.append("Result:\t\t\(String(describing: response.result.value))\n")
                
                if shouldLogError {
                    logString.append("Error:\t\t\(error.debugDescription)")
                }
                
                logString.append("\n---------------  Related Request Content  --------------\n")
                logString.append("URL:\t\t\t\(response.request?.url?.absoluteString ?? "N/A")\n")
                logString.append("Header Filds:\n\t\t\t\(String(describing: response.request?.allHTTPHeaderFields))\n")
                logString.append("Body:\n\t\t\(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "N/A")\n")
                
            logString.append("\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n")
                NSLog(logString)
            #endif
    }
}
