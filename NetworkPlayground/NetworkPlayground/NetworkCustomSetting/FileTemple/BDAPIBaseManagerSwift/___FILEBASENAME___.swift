//
//

import UIKit
import BDNetworking

enum ___FILEBASENAMEASIDENTIFIER___ResponseError: Int, Error, LocalizedError {
    case `default` = 0
    
    var localizedDescription: String {
        get {
            switch self {
            case .default:
                return "网络异常，请检查网络"
            }
        }
    }
}

public class ___FILEBASENAMEASIDENTIFIER___: BDAPIBaseManager {
    // MARK: - override
    required public init() {
        super.init()
        self.validator = self
    }
    
    override public func reformParams(params: [String : Any]?) -> [String : Any]? {
        var new: [String: Any] = params ?? [:]
        
        return super.reformParams(params: new)
    }

}

extension ___FILEBASENAMEASIDENTIFIER___: BDAPIManagerProtocal {
    public func shouldLoadFromNative() -> Bool {
        return false
    }
    
    public func shouldCache() -> Bool {
        return false
    }
    
    public func requestType() -> BDAPIRequestType {
        return .post
    }
    
    public func serviceType() -> String {
        return ___BDServiceType___
    }
    
    public func serviceBundleName() -> String {
        return "BDNetworkExtension"
    }
    
    public func relativeUrl() -> String {
        return "___RelativeUrl___"
    }
}

extension ___FILEBASENAMEASIDENTIFIER___: BDAPIManagerValidator {
    public func isCallBackCorrect(manager: BDAPIBaseManager, callBackData: Any?) -> Bool {
        return true
    }
    
    public func isRequestParamsCorrect(manager: BDAPIBaseManager, params: [String : Any]?) -> Bool {
        return true
    }
}
