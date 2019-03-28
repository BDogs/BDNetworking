//
//  BDServiceFactory.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation
protocol BDServiceFactoryDataSource {
    /*
     * key为service的Identifier
     * value为service的Class的字符串
     */
    func servicesKindsOfServiceFactory() -> [String: String]
}

class BDServiceFactory: NSObject {
    static let kBDServiceDefault = "BDDefautService"
    static let shareInstance = BDServiceFactory()
    var serviceStorage: [String: BDService] = [:]
    
    
    
    
    /// 根据 Identifier 获取 Service
    ///
    /// - Parameter identifier: 继承于 BDService 类的名
    /// - Returns: BDService
    public func serviceWithIdentifier(identifier: String) -> BDService? {
        if serviceStorage[identifier] == nil {
            serviceStorage[identifier] = newService(identifier: identifier)
        }
        return serviceStorage[identifier]
    }
    
    fileprivate func newService(identifier: String) -> BDService? {
//        if identifier == BDServiceFactory.kBDServiceDefault  {
        //Bundle.main
            var appName: String? = Bundle(for: BDServiceFactory.self).object(forInfoDictionaryKey: "CFBundleName") as! String?
            appName = appName?.replacingOccurrences(of: "-", with: "_")
            let Cls = NSClassFromString(appName! + "." + identifier) as? BDService.Type
            let service = Cls?.init()
            
            return service
//        }
//        return nil
    }
    
    
}
