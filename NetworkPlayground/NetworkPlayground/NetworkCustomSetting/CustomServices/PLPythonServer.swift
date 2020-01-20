//
//  PLPythonDevelopmentServer.swift
//  PinsLife
//
//  Created by 诸葛游 on 2018/10/26.
//Copyright © 2018 品驰医疗. All rights reserved.
//

import Foundation


class PLPythonServer: BDService, BDServiceProtocol {
    var fields: [String: String] {
        get {
            var parms = ["pins-app-version": AppContext.appVersion,
                         "pins-device": "957BE52C-ACBE-434D-97D7-DA5921AC508E",//DiviceInfo.UUIDString,
                         "pins-timestamp": String(format: "%.f", AppContext.timestamp/1000),
                         "pins-source": "4"]
            parms["Authorization"] = "PINSV1 \(BDNetworkingContext.shared.accessToken ?? "")"
            return parms
        }
    }
    
    static let picServicePath = "http://pins-app-resources.oss-cn-qingdao.aliyuncs.com/"
    
    
    // token 失效
    public static let kNotification_tokenInvalid = "kNotification_tokenInvalid"
    
    public static let kUserInfo_urlRequestToContinue = "kUserInfo_urlRequestToContinue"
    
    public static let kUserInfo_serviceToContinue = "kUserInfo_serviceToContinue"
    
    fileprivate let kTokenStatus = "kTokenStatus"
    
    /// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
    func shouldCallBackByFailedOnCallingAPI(response: BDDataResponse<Any>?) -> Bool {
        let dic = response?.result.value as? [String: Any]
        if ((dic?[kTokenStatus] as? String) != nil) && dic?[kTokenStatus] as! String == "expired_access_token" {
            let notificationName = Notification.Name(rawValue: BDDefautService.kNotification_tokenInvalid)
            
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [BDDefautService.kUserInfo_urlRequestToContinue: response!.request!, BDDefautService.kUserInfo_serviceToContinue: self])
        }
        
        return true
    }
    
    
    // MARK: - BDServiceProtocol
    var isOnline: Bool {
        return BDNetworkingContext.shared.isOnline
    }
    
    var offlineApiBaseUrl: String {
        switch BDNetworkingContext.shared.environmentCode {
        case 0: return "http://192.168.1.248:58080/api2"
        case 1: return "http://192.168.1.207:8090/api2"
        case 2: return "https://pinslife.pinsmedical.com/api2"
        default:
            return ""
        }
    }
    
    var onlineApiBaseUrl: String {
        return "https://pinslife.pinsmedical.com/api2"
    }
    
    var offlineHeaderFields: [String : String] {
        return fields
    }
    
    var onlineHeaderFields: [String : String] {
        return fields
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
        return [:]
    }
    
    var offlineExtraParmas: [String: Any] {
        return [:]
    }
    
    var onlineExtraHeaderFields: [String : String] {
        return [:]//pks_commenParams
    }
    
    var offlineExtraHeaderFields: [String : String] {
        return [:]//pks_commenParams
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
