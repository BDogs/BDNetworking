//
//

import UIKit
import BDNetworking

enum PLAppointmentDoctorRefuseAPIManagerResponseError: Int, Error, LocalizedError {
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

class PLAppointmentDoctorRefuseAPIManager: BDAPIBaseManager {
    // MARK: - override
    required init() {
        super.init()
        self.validator = self
    }
    
    override func reformParams(params: [String : Any]?) -> [String : Any]? {
        var new: [String: Any] = params ?? [:]
        
        return super.reformParams(params: new)
    }

}

extension PLAppointmentDoctorRefuseAPIManager: BDAPIManagerProtocal {
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
        return BDServiceIdentifier.kPLPythonServer
    }
    
    func serviceBundleName() -> String {
        return "BDNetworkExtension"
    }
    
    func relativeUrl() -> String {
        return "appointment/doctorRefuse"
    }
}

extension PLAppointmentDoctorRefuseAPIManager: BDAPIManagerValidator {
    func isCallBackCorrect(manager: BDAPIBaseManager, callBackData: Any?) -> Bool {
        return true
    }
    
    func isRequestParamsCorrect(manager: BDAPIBaseManager, params: [String : Any]?) -> Bool {
        return true
    }
}
