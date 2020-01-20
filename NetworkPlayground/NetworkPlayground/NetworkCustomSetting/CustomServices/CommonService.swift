//
//  CommonService.swift
//  PksDoctor
//
//  Created by 诸葛游 on 2017/6/2.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation


class CommonService: BDService, BDServiceProtocol {

//    let pks_commenParams: [String: [String: Any]] = {
//        let parms = ["header": ["appVersion": AppContext.shared.appVersion,
//                                "imei": DiviceInfo.UUIDString,
//                                "msgId": AppContext.shared.timestamp,
//                                "scope": "qingdao",
//                                "source": 4,
//                                "userClass": 102,
//                                "userid": AppContext.shared.userId ]]
//        return parms
//    }()
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
        //        return "http://192.168.1.205:80/api/CommonAPI"
        return "http://192.168.1.207:8087"
    }
    
    var onlineApiBaseUrl: String {
        //        return "http://192.168.1.207:8080/appserver"
        return "http://dbbase.pjssd.org"
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
        return [:]//CommonService().pks_commenParams
    }
    
    var offlineExtraParmas: [String: Any] {
        return [:]//CommonService().pks_commenParams
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
