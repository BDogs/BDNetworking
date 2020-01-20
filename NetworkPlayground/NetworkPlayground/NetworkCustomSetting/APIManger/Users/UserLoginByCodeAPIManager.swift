//
//  UserLoginByCodeAPIManager.swift
//  PinsLife
//
//  Created by 诸葛游 on 2018/7/30.
//Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation

enum UserLoginByCodeAPIManagerResponseError: Int, Error, LocalizedError {
    case `default` = 0
    case accountNull = 100
    case codeNull = 101
    case disabledAccont = 102
    case codeError = 103
    case invalidAccount = 104
    case invalidCode = 105
    
    var localizedDescription: String {
        get {
            switch self {
            case .default:
                return "网络异常，请检查网络"
            case .accountNull:
                return "请输入手机号！"
            case .codeNull:
                return "请输入验证码！"
            case .disabledAccont:
                return "账号禁止登录，请联系客服！"
            case .codeError:
                return "验证码输入有误，请重试！"
            case .invalidAccount:
                return "无效的用户名"
            case .invalidCode:
                return "验证码已失效，请重新获取"
            }
        }
    }
}

class UserLoginByCodeAPIManager: BDAPIBaseManager {
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

extension UserLoginByCodeAPIManager: BDAPIManagerProtocal {
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
        return BDServiceIdentifier.kPLPythonServer//.kPinsLifeService
    }
    
    func relativeUrl() -> String {
        return "user/login/3"//"user/login/2_2"
    }
}

extension UserLoginByCodeAPIManager: BDAPIManagerValidator {
    func isCallBackCorrect(manager: BDAPIBaseManager, callBackData: Any?) -> Bool {
        return true
    }
    
    func isRequestParamsCorrect(manager: BDAPIBaseManager, params: [String : Any]?) -> Bool {
        return true
    }
}
