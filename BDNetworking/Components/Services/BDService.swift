//
//  BDService.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

public protocol BDServiceProtocol {
    var isOnline: Bool { get }
    
    var offlineApiBaseUrl: String { get }
    var onlineApiBaseUrl: String { get }
    
    var offlineApiVersion: String { get }
    var onlineApiVersion: String { get }
    
    var onlinePublicKey: String { get }
    var offlinePublicKey: String { get }
    
    var onlinePrivateKey: String { get }
    var offlinePrivateKey: String { get }
    
    var onlineHeaderFields: [String: String] { get }
    var offlineHeaderFields: [String: String] { get }
    
    var onlineExtraParmas: [String: Any] { get }
    var offlineExtraParmas: [String: Any] { get }
    
    var onlineExtraHeaderFields: [String: String] { get }
    var offlineExtraHeaderFields: [String: String] { get }

    
    /// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
    func shouldCallBackByFailedOnCallingAPI(response: BDDataResponse<Any>?) -> Bool
}

open class BDService: NSObject {

    public lazy var child: BDServiceProtocol? = {
        return self as? BDServiceProtocol
    }()

    public required override init() {
        
    }
    
    public var privateKey: String {
        return ((child?.isOnline)! ? child?.onlinePrivateKey : child?.offlinePrivateKey)!
    }
    
    public var publicKey: String {
        return ((child?.isOnline)! ? child?.onlinePublicKey : child?.offlinePublicKey)!
    }
    
    public var apiBaseUrl: String {
        return ((child?.isOnline)! ? child?.onlineApiBaseUrl : child?.offlineApiBaseUrl)!
    }
    
    public var apiVersion: String {
        return ((child?.isOnline)! ? child?.onlineApiVersion : child?.offlineApiVersion)!
    }
    
    public var headerFields: [String: String] {
        return ((child?.isOnline)! ? child?.onlineHeaderFields : child?.offlineHeaderFields)!
    }
    
    public var extraParams: [String: Any] {
        return ((child?.isOnline)! ? child?.onlineExtraParmas : child?.offlineExtraParmas)!
    }
    
    public var extraHeaderFields: [String: String] {
        return ((child?.isOnline)! ? child?.onlineExtraHeaderFields : child?.offlineExtraHeaderFields) ?? [:]
    }
    
    
    /// 子类可以 override，用于 Service 定制拼接方式， override 后不需要 super 调用
    open func appendURL(relativeUrl: String) -> String {
        var urlString: String
        if self.apiVersion.isEmpty {
            urlString = self.apiBaseUrl + "/" + relativeUrl
        } else {
            urlString = self.apiBaseUrl + "/" + self.apiVersion + "/" + relativeUrl
        }
        return urlString
    }
    
    
}


