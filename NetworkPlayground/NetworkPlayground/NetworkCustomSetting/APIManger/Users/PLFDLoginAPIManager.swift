//
//  PLFDLoginAPIManager.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/12/1.
//Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

enum PLFDLoginAPIError: Int, Error, LocalizedError {
    case `default` = 0
    case telNull = 100
    case pwdNull = 101
    case telOrPwdFault = 102
    case invalidUsername = 103
    case failed = 104
    
    var localizedDescription: String {
        get {
            switch self {
            case .default:
                return "网络异常，请检查网络"
            case .telNull:
                return "请输入用户名!"
            case .pwdNull:
                return "请输入密码!"
            case .invalidUsername:
                return "账号不可用!"
            case .telOrPwdFault, .failed:
                return "用户名或密码错误!"
            }
        }
    }
}

class PLFDLoginAPIManager: BDAPIBaseManager {
    // MARK: - override
    required init() {
        super.init()
        self.validator = self
    }
    
    override func reformParams(params: [String : Any]?) -> [String : Any]? {
        let new: [String: Any] = params ?? [:]
        
        return super.reformParams(params: new)
    }

}

extension PLFDLoginAPIManager: BDAPIManagerProtocal {
    func serviceBundleName() -> String {
        return "NetworkPlayground"
    }
    
    func shouldLoadFromNative() -> Bool {
        return false
    }
    
    func shouldCache() -> Bool {
        return false
    }
    
    func requestType() -> BDAPIRequestType {
        return .post
    }
    
    func serviceType() -> String {
        return BDServiceIdentifier.kPLPythonServer//"PinsLifeService"
    }
    
    func relativeUrl() -> String {
        return "doctor/login"
    }
}

extension PLFDLoginAPIManager: BDAPIManagerValidator {
    func isCallBackCorrect(manager: BDAPIBaseManager, callBackData: Any?) -> Bool {
        return true
    }
    
    func isRequestParamsCorrect(manager: BDAPIBaseManager, params: [String : Any]?) -> Bool {
        return true
    }
}
