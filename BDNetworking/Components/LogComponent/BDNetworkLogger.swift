//
//  BDNetworkLogger.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/19.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation

public extension Notification.Name {
    static let BDNetworkLoggerDidUpudate = Notification.Name.init(rawValue: "BDNetworkLoggerDidUpudate")
}

public class BDNetworkLogger: NSObject {

    public static let shared = BDNetworkLogger()
    lazy var configParams = BDLoggerConfiguration()
    
    public var cacheslimit = 50
    
    public var caches: [String] = [] {
        didSet {
            if caches.count >= cacheslimit {
                caches.removeAll()
            }
            NotificationCenter.default.post(name: .BDNetworkLoggerDidUpudate, object: nil, userInfo: nil)
        }
    }
    
    
    public override init() {
        super.init()
//        configParams.configWithAppType(appType: .xxx)
    }
    
    
    public func logDebugInfo(
        request: URLRequest,
        relativeUrl: String?,
        service: BDService,
        requestParams: [String: Any]?)
        -> Void {
            
            #if DEBUG
            let isOnline = service.child!.isOnline
            var logString = "\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"
            let date = Date()
            
            let params = requestParams ?? [:]
            let paramJson = params.json() ?? "Json Error"
            let allHTTPHeaderFields = request.allHTTPHeaderFields ?? [:]
            let allHTTPHeaderFieldsJson = allHTTPHeaderFields.json() ?? "Json Error"
            
            logString.append("Date:\t\t\t\t\(date.description(with: Locale.current))\n")
            logString.append("API Name:\t\t\t\(relativeUrl ?? "N/A")\n")
            logString.append("HTTPMethod:\t\t\t\(request.httpMethod ?? "N/A")\n")
            logString.append("API Verison:\t\t\t\(service.apiVersion)\n")
            logString.append("Status:\t\t\t\t\(isOnline ? "online":"offline")\n")
            logString.append("Public Key:\t\t\t\(service.publicKey)\n")
            logString.append("Private Key:\t\t\t\(service.privateKey)\n")
            logString.append("Service Name:\t\t\(type(of: service))\n")
            logString.append("URL:\t\t\t\t\(request.url?.absoluteString ?? "N/A")\n")
            logString.append("Params:\n->\(paramJson)\n")
            
            logString.append("Header Filds:\n->\(allHTTPHeaderFieldsJson)\n")
            logString.append("Body:\n->\(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "N/A")\n")
            logString.append("\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n")
            print(logString)
            caches.append(logString)
            #endif
    }
    
    public func logDebugInfo(
        response: BDDataResponse<Any>,
        error: Error?)
        -> Void {
            #if DEBUG
            let shouldLogError = error == nil ? true : false
            var logString = "\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"
            
            let date = Date()
            let resultDefault = String(describing: response.result.value) 
            var resultJson: String = resultDefault
            if let temp = response.result.value as? [String: Any] {
                resultJson = temp.json() ?? resultDefault
            }
            
            if let temp = response.result.value as? [Any] {
                resultJson = temp.json() ?? resultDefault
            }
            
            let allHTTPHeaderFields = response.request?.allHTTPHeaderFields ?? [:]
            let allHTTPHeaderFieldsJson = allHTTPHeaderFields.json() ?? "Json Error"
            
            logString.append("Date:\t\t\t\t\(date.description(with: Locale.current))\n")
            
            logString.append("Status Code:\t\t\t\(String(describing: response.response?.statusCode ?? 0))\n")
            logString.append("Result:\t\t\(resultJson)\n")
            
            if shouldLogError {
                logString.append("Error:\t\t\(error.debugDescription)")
            }
            
            logString.append("\n---------------  Related Request Content  --------------\n")
            logString.append("URL:\t\t\t\(response.request?.url?.absoluteString ?? "N/A")\n")
            logString.append("Header Filds:\n->\(allHTTPHeaderFieldsJson)\n")
            logString.append("Body:\n->\(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "N/A")\n")
            
            logString.append("\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n")
            print(logString)
            caches.append(logString)

            #endif
    }
}

