//
//  BDRequestGenerator.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import Alamofire

public enum BDParameterEncoding {
    case json
    case url
    case propertyList
    
    var encoding: ParameterEncoding {
        get {
            switch self {
            case .json:
                return JSONEncoding.default
            case .url:
                return URLEncoding.default
            
            case .propertyList:
                return PropertyListEncoding.default
            }
        }
    }
    
}

class BDRequestGenerator {
    
    static let shareInstance = BDRequestGenerator()
    
    // MARK: - public func
    ///
    public func gernerateApiRequest (
        serviceIdentifier: String,
        serviceBundleName: String,
        requestParams: [String: Any]? = nil,
        relativeUrl: String,
        method: BDAPIRequestType = .get,
        encodingType: BDParameterEncoding)
        -> URLRequest? {
            guard let service = BDServiceFactory.shareInstance.serviceWithIdentifier(identifier: serviceIdentifier, bundleName: serviceBundleName) else {
                // 这里认为 Service 为 nil，它的生成失败是派生类的定义有问题，需要提醒开发者
                return nil
            }
            
            var urlString = service.appendURL(relativeUrl: relativeUrl)
            
            var params: [String: Any]? = requestParams == nil ? [:] : requestParams!
            
            
            // 添加全局公共参数
            let commonParams = BDCommonParamsGenerator.commonParamsDictionary()
            for (key, value) in commonParams {
                params?[key] = value
            }
            
//            // 添加 Service 的 extraParmas
//            let extraParmas = service?.extraParams
//            for (key, value) in extraParmas! {
//                params?[key] = value
//            }
            
            if method == .get {
                if let theParams = params {
                    urlString += "?"
                    
                    for (key, value) in theParams {
                        urlString += "\(key)=\(value)&"
                    }
                    urlString.remove(at: urlString.index(before: urlString.endIndex))
                }
                params = nil
            }
            
            
            
            // Alamofire 创建 URLRequest
            var request: URLRequest?
            let encoding: ParameterEncoding = encodingType.encoding//URLEncoding.default//JSONEncoding.default
            do {
                request = try URLRequest(url: urlString, method: HTTPMethod(rawValue: method.rawValue)!, headers: service.headerFields)
                request = try encoding.encode(request!, with: params)
            } catch {
                request = nil
            }
            
//            request?.requestParams = params
//            request?.service = service
            return request
    }
    
    public func generateGETRequest(
        serviceIdentifier: String,
        serviceBundleName: String,
        requestParams: [String: Any]? = nil,
        relativeUrl: String,
        encodingType: BDParameterEncoding)
        -> URLRequest? {
            return gernerateApiRequest(serviceIdentifier: serviceIdentifier, serviceBundleName: serviceBundleName, requestParams: requestParams, relativeUrl: relativeUrl, method: .get, encodingType: encodingType)
    }
    
    func generatePOSTRequest(
        serviceIdentifier: String,
        serviceBundleName: String,
        requestParams: [String: Any]? = nil,
        relativeUrl: String,
        encodingType: BDParameterEncoding)
        -> URLRequest? {
            return gernerateApiRequest(serviceIdentifier: serviceIdentifier, serviceBundleName: serviceBundleName, requestParams: requestParams, relativeUrl: relativeUrl, method: .post, encodingType: encodingType)
    }
    
    func generatePUTRequest(
        serviceIdentifier: String,
        serviceBundleName: String,
        requestParams: [String: Any]? = nil,
        relativeUrl: String,
        encodingType: BDParameterEncoding)
        -> URLRequest? {
            return gernerateApiRequest(serviceIdentifier: serviceIdentifier, serviceBundleName: serviceBundleName, requestParams: requestParams, relativeUrl: relativeUrl, method: .put, encodingType: encodingType)
    }
    
    func generateDELETERequest(
        serviceIdentifier: String,
        serviceBundleName: String,
        requestParams: [String: Any]? = nil,
        relativeUrl: String,
        encodingType: BDParameterEncoding)
        -> URLRequest? {
            return gernerateApiRequest(serviceIdentifier: serviceIdentifier, serviceBundleName: serviceBundleName, requestParams: requestParams, relativeUrl: relativeUrl, method: .delete, encodingType: encodingType)
    }
    
    // TODO: TODO：上传和下载
    func generateUPLOADRequest() -> URLRequest? {
        return nil
    }
    
    func generateDOWNLOADRequest() -> URLRequest? {
        return nil
    }
}

