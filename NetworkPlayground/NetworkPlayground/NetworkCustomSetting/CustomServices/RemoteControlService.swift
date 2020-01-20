//
//  RemoteControlService.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/7/25.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation


class RemoteControlService: BDService, BDServiceProtocol {
    
    let commenParams: [String: [String: Any]] = {
        return ["header": ["appVersion": AppContext.appVersion,
                           "imei": DiviceInfo.UUIDString,
                           "msgId": AppContext.timestamp,
                           "timestamp": String(format: "%.f", AppContext.timestamp),
                           "source": 6]]
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
        switch BDNetworkingContext.shared.environmentCode {
        case 0:
            return "http://192.168.1.222:31857/api/PinsTele/APIs"//"https://192.168.1.248:448/api/PinsTele/APIs"////"https://192.168.1.248:448/api/PinsTele/APIs"
        case 1:
            return "https://192.168.1.204:444/api/PinsTele/APIs" // 测试环境
        case 2:
            return "https://pinsmedical.com:446/api/PinsTele/APIs"
//            return "https://pinsmedical.com:448/api/PinsTele/APIs"
        default:
            return ""
        }
    }
    
    var onlineApiBaseUrl: String {
        return "https://pinsmedical.com:446/api/PinsTele/APIs"
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
        return RemoteControlService().commenParams
    }
    
    var offlineExtraParmas: [String: Any] {
        return RemoteControlService().commenParams
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
            urlString = self.apiBaseUrl
        } else {
            urlString = self.apiBaseUrl + "/" + self.apiVersion
        }
        return urlString
    }

}
