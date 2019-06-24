//
//  BDServiceFactory.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation
public protocol BDServiceFactoryDataSource {
    /*
     * key为service的Identifier
     * value为service的Class的字符串
     */
    func servicesKindsOfServiceFactory() -> [String: String]
}

public class BDServiceFactory: NSObject {
    public static let kBDServiceDefault = "BDDefautService"
    public static let shareInstance = BDServiceFactory()
    public var serviceStorage: [String: BDService] = [:]
    
    
    
    
    /// 根据 Identifier 获取 Service
    ///
    /// - Parameter identifier: 继承于 BDService 类的名
    /// - Returns: BDService
    public func serviceWithIdentifier(identifier: String, bundleName: String) -> BDService? {
        if serviceStorage[identifier] == nil {
            serviceStorage[identifier] = newService(identifier: identifier, bundleName: bundleName)
        }
        return serviceStorage[identifier]
    }
    
    fileprivate func newService(identifier: String, bundleName: String) -> BDService? {
//        if identifier == BDServiceFactory.kBDServiceDefault  {
        //Bundle.main
//            var appName: String? = Bundle(for: BDServiceFactory.self).object(forInfoDictionaryKey: "CFBundleName") as! String?
//            appName = appName?.replacingOccurrences(of: "-", with: "_")
        guard let Cls = NSClassFromString(bundleName + "." + identifier) as? BDService.Type else { return nil }
        let service = Cls.init()
        return service
    }
    
    
}
