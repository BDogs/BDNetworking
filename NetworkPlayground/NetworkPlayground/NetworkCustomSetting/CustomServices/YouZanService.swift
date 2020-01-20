//
//  YouZanService.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/11/15.
//Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

class YouZanService: BDService, BDServiceProtocol {
    var onlineExtraHeaderFields: [String : String] {
        return [:]
    }
    
    var offlineExtraHeaderFields: [String : String] {
        return [:]
    }
    
 
    
    /// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
    func shouldCallBackByFailedOnCallingAPI(response: BDDataResponse<Any>?) -> Bool {
        
        return true
    }
    
    
    // MARK: - BDServiceProtocol
    var isOnline: Bool {
        return BDNetworkingContext.shared.isOnline
    }
    
    var offlineApiBaseUrl: String {
        return "https://uic.youzan.com/sso/open"
    }
    
    var onlineApiBaseUrl: String {
        return "https://uic.youzan.com/sso/open"
    }
    
    var offlineHeaderFields: [String : String] {
        return [:]//["Content-Type": "multipart/form-data"]
    }
    
    var onlineHeaderFields: [String : String] {
        return [:]//["Content-Type": "multipart/form-data"]
    }
    
    var offlinePrivateKey: String {
        return ""
    }
    
    var onlinePrivateKey: String {
        return ""
    }
    
    var offlinePublicKey: String {
        return ""
    }
    
    var onlinePublicKey: String {
        return ""
    }
    
    var onlineApiVersion: String {
        return ""
    }
    
    var offlineApiVersion: String {
        return ""
    }
    
    var onlineExtraParmas: [String: Any] {
        return ParkinsonService().pks_commenParams
    }
    
    var offlineExtraParmas: [String: Any] {
        return ParkinsonService().pks_commenParams
    }
    
    // 重载，定制 URL 的拼接规则
    override func appendURL(relativeUrl: String) -> String {
        var urlString: String
        if self.apiVersion.isEmpty {
            urlString = self.apiBaseUrl + "/" + relativeUrl
        } else {
            urlString = self.apiBaseUrl + "/" + self.apiVersion + "/" + relativeUrl
        }
        return urlString
    }

}
