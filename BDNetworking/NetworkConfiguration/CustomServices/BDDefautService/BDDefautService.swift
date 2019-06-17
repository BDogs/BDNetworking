//
//  BDDefautService.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation
public class BDDefautService: BDService, BDServiceProtocol {
    
    // token 失效
    public static let kNotification_tokenInvalid = "kNotification_tokenInvalid"

    public static let kUserInfo_urlRequestToContinue = "kUserInfo_urlRequestToContinue"
    
    public static let kUserInfo_serviceToContinue = "kUserInfo_serviceToContinue"
    
    fileprivate let kTokenStatus = "kTokenStatus"
    
    /// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
    public func shouldCallBackByFailedOnCallingAPI(response: BDDataResponse<Any>?) -> Bool {
        let dic = response?.result.value as? [String: Any]
        if ((dic?[kTokenStatus] as? String) != nil) && dic?[kTokenStatus] as! String == "expired_access_token" {
            let notificationName = Notification.Name(rawValue: BDDefautService.kNotification_tokenInvalid)
            
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [BDDefautService.kUserInfo_urlRequestToContinue: response!.request!, BDDefautService.kUserInfo_serviceToContinue: self])
        }
        
        return true
    }


    // MARK: - BDServiceProtocol
    public var isOnline: Bool {
        return BDNetworkingContext.shared.isOnline
    }
    
    public var offlineApiBaseUrl: String {
       return ""
    }
    
    public var onlineApiBaseUrl: String {
        return ""
    }
    
    public var offlineHeaderFields: [String : String] {
        return [:]
    }
    
    public var onlineHeaderFields: [String : String] {
        return [:]
    }
    
    public var offlinePrivateKey: String {
        return ""
    }
    
    public var onlinePrivateKey: String {
        return ""
    }
    
    public var offlinePublicKey: String {
        return ""
    }
    
    public var onlinePublicKey: String {
        return ""
    }
    
    public var onlineApiVersion: String {
        return ""
    }
    
    public var offlineApiVersion: String {
        return ""
    }
    
    public var onlineExtraParmas: [String: Any] {
        return [:]
    }
 
    public var offlineExtraParmas: [String: Any] {
        return [:]
    }
    
    public var onlineExtraHeaderFields: [String : String] {
        return [:]
    }
    
    public var offlineExtraHeaderFields: [String : String] {
        return [:]
    }
    
    
    // 重载，定制 URL 的拼接规则
    override public func appendURL(relativeUrl: String) -> String {
        var urlString: String
        if self.apiVersion.isEmpty {
            urlString = self.apiBaseUrl + "/" + relativeUrl
        } else {
            urlString = self.apiBaseUrl + "/" + self.apiVersion + "/" + relativeUrl
        }
        return urlString
    }

}

