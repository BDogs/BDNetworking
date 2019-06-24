//
//  BDAPIProxy.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/12.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Alamofire

public enum BDAPIRequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

@objc public class BDAPIProxy: NSObject {
    public static let defaultHTTPHeaders: HTTPHeaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                
                let alamofireVersion: String = {
                    guard
                        let afInfo = Bundle(for: SessionManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                        else { return "Unknown" }
                    
                    return "BDNetworking/\(build)"
                }()
                
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
            }
        
            return "BDNetworking"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "192.168.1.204": .disableEvaluation,
        "192.168.1.248": .disableEvaluation,
//        "https://pinsmedical.com": .pinCertificates(
//            certificates: ServerTrustPolicy.certificates(),
//            validateCertificateChain: true,
//            validateHost: true
//        ),
        "https://pinsmedical.com": .disableEvaluation
    ]
    
    public lazy var sessionConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = BDNetworkingConfiguration.timeoutIntervalForRequest
        configuration.requestCachePolicy = .useProtocolCachePolicy
//        configuration.httpAdditionalHeaders = BDAPIProxy.defaultHTTPHeaders

        return configuration
    }()
    
    public static let shareInstance = BDAPIProxy()
    // 请求任务调度队列
    public lazy var dispatchTable: [Int: URLSessionTask] = [:]
    
    lazy var manager: SessionManager = {
         var manager = SessionManager(configuration: self.sessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies))
        return manager
    }()
        
    // MARK: - public func completionHandler
    /// 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可
    public func callApi(
        serviceIdentifier: String,
        serviceBundleName: String,
        relativeUrl: String,
        params: [String: Any]? = nil,
        method: BDAPIRequestType = .get,
        encodingType: BDParameterEncoding,
        completionHandler: @escaping (BDDataResponse<Any>) -> Void)
        -> Int {
            
            let request = BDRequestGenerator.shareInstance.gernerateApiRequest(serviceIdentifier: serviceIdentifier, serviceBundleName: "serviceBundleName", requestParams: params, relativeUrl: relativeUrl, method: method, encodingType: encodingType)
            
            guard request != nil else {
                self.requestCompleted(request: nil, task: nil, response: nil, data: nil, error: BDError.generateURLRequestFailed, completionHandler: completionHandler)
                return 0
            }
            let service = BDServiceFactory.shareInstance.serviceWithIdentifier(identifier: serviceIdentifier, bundleName: serviceBundleName)
            // log
            BDNetworkLogger.shared.logDebugInfo(request: request!, relativeUrl: relativeUrl, service: service!, requestParams: params)
            
            var dataRequest: DataRequest?
            dataRequest = manager.request(request!).responseData { (response) in
                
                self.requestCompleted(request: request!, task: dataRequest!.task!, response: response.response, data: response.data, error: response.error, completionHandler: completionHandler)
            }
            let requestId = dataRequest?.task?.taskIdentifier
            dispatchTable[requestId!] = dataRequest?.task!
        return requestId!
    }
    
    // TODO:- TODO：上传和下载

    public func fetchTaskFromDispatchTable(requestId: Int) -> URLSessionTask? {
       return dispatchTable[requestId]
    }
    
    public func cancelARequest(requestId: Int) -> Void {
        guard dispatchTable.keys.contains(requestId) else {
            return
        }
        let task = dispatchTable[requestId]
        task?.cancel()
        dispatchTable.removeValue(forKey: requestId)
    }
    
    public func cancelRequests(requestIdList: [Int]) -> Void {
        for requestId in requestIdList {
            cancelARequest(requestId: requestId)
        }
    }
    
    // MARK: - priviate func
    /// 处理请求结果
    private func requestCompleted(
        request: URLRequest?,
        task: URLSessionTask?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        completionHandler: @escaping (BDDataResponse<Any>) -> Void)
        -> Void {
            
            let requestId = task?.taskIdentifier ?? 0
            // 从调度队列里移除已经完成的 task
            dispatchTable.removeValue(forKey: requestId)
            
            // 解析 JSON
            let result = BDResponseSerialization.serializeResponseJSON(response: response, data: data, error: error)
            let dataResponse = BDDataResponse(request: request, requestId: requestId, response: response, data: data, result: result)
            // log
            BDNetworkLogger.shared.logDebugInfo(response: dataResponse, error: dataResponse.result.error)
            
            completionHandler(dataResponse)
    }
    
}
