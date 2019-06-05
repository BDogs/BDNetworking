//
//  BDNetworkingContext.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Alamofire

enum BDAppType {
    case xxx
}

public struct BDServiceIdentifier {
    public static let kPinsLifeService = "PinsLifeService"
    public static let kPLPythonServer = "PLPythonServer"
    public static let kPLTeleParseServer = "PLTeleParseServer"
    public static let kPLProductService = "PLProductService"
}

public class BDNetworkingConfiguration {
    public static let shouldCache = true
    public static let timeoutIntervalForRequest: TimeInterval = 30.0
    public static let cacheOutdateTimeSeconds: TimeInterval = 300.0
    public static let cacheCountLimit: Int = 1000
}

public enum BDNetworkingEnvironmentCode: Int {
    case develep = 0
    case testing
    case production
    
    public var description: String {
        get {
            switch self {
            case .develep:
                return "开发环境"
            case .testing:
                return "测试环境"
            case .production:
                return "生产环境"
            }
        }
    }
}

public class BDNetworkingContext: NSObject {
    public static let shared = BDNetworkingContext()
    public var environmentCode: Int = 0
    public var accessToken: String?
    
    lazy var settings: [String: Any]? = {
        let filePath = Bundle(for: BDNetworkingContext.self).path(forResource: "BDNetworkingConfiguration", ofType: "plist")
        return NSDictionary.init(contentsOfFile: filePath!) as? [String : Any]
    }()
    
   public lazy var isOnline: Bool = {
        let temp: NSNumber = (self.settings!["isOnline"] as? NSNumber)!
        return temp.boolValue
    }()
    
    lazy var reachabilityManager = NetworkReachabilityManager.init()
    
    public var isReachable: Bool {
        get {
            return (reachabilityManager?.isReachable)!
        }
    }
    
    var isReachableOnWWAN: Bool  {
        get {
            return (reachabilityManager?.isReachableOnWWAN)!
        }
    }
    
    var isReachableOnEthernetOrWiFi: Bool {
        get {
            return (reachabilityManager?.isReachableOnEthernetOrWiFi)!
        }
    }
    
    public func listen(call: @escaping ((_ isReachable: Bool) -> Void)) -> Void {
        reachabilityManager?.listener = { [weak self] (status) in
           call(self?.isReachable ?? false)
        }
        reachabilityManager?.startListening()
    }
    
    // updateTokenAPIManager
}
