//
//  ParkinsonService.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/5/4.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

class ParkinsonService: BDService, BDServiceProtocol {
    

//    static let pks_commenParams: [String: [String: Any]] = ["header": ["appVersion": AppContext.shared.appVersion,
//                                                             "imei": DiviceInfo.UUIDString,
//                                                             "msgId": AppContext.shared.timestamp,
//                                                             "scope": "qingdao",
//                                                             "source": 4,
//                                                             "userClass": 101,
//                                                             "userid": AppContext.shared.userId ]]
    
    let pks_commenParams: [String: [String: Any]] = {
//        let parms = ["header": ["appVersion": AppContext.shared.appVersion,
//                                "imei": DiviceInfo.UUIDString,
//                                "msgId": AppContext.shared.timestamp,
//                                "scope": AppContext.shared.scope,
//                                "source": 4,
//                                "userClass": 101,
//                                "userid": AppContext.shared.userId ]]
//        return parms
        return [:]
    }()
    
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
//        return "http://192.168.1.201:8080/appserver"
//        return "http://192.168.1.205:9090/appserver"
        
        return "http://192.168.1.207:8080/appserver"

//        return "http://pinsmedical.com:9090/appserver"
    }
    
    var onlineApiBaseUrl: String {
        return "http://dbbase.pjssd.org:9090/appserver/"
//        return "http://192.168.1.207:8080/appserver"
//        return "http://pinsmedical.com:9090/appserver"
    }
    
    var offlineHeaderFields: [String : String] {
        return [:]
    }
    
    var onlineHeaderFields: [String : String] {
        return [:]
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
    
    var onlineExtraHeaderFields: [String : String] {
        return [:]
    }
    
    var offlineExtraHeaderFields: [String : String] {
        return [:]
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
