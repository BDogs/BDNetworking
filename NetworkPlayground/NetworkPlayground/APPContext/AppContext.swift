//
//  AppContext.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/20.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UserNotifications

public struct TokenHandel {
    public static let kAccessToken = "kAccessToken"
    public static let kLastRefreshTime = "kLastRefreshTime"
    
    public var accessToken: String? {
        get {
            return UserDefaults.standard.value(forKey: TokenHandel.kAccessToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TokenHandel.kAccessToken)
        }
    }
    
    public var lastRefreshTime: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: TokenHandel.kLastRefreshTime) as TimeInterval
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TokenHandel.kLastRefreshTime)
        }
    }
    
    public mutating func updateToken(accessToken: String) -> Void {
        self.accessToken = accessToken
        self.lastRefreshTime = Date().timeIntervalSince1970 * 1000
    }
    
    public mutating func clear() -> Void {
        self.accessToken = nil
        self.lastRefreshTime = 0
        
        UserDefaults.standard.removeObject(forKey: TokenHandel.kLastRefreshTime)
        UserDefaults.standard.removeObject(forKey: TokenHandel.kAccessToken)
    }
}

public class DiviceInfo {
    
    public static let type = "OSX"
    // e.g. "My iPhone"
    public static let name: String = ""//GDevice.current.name
    // e.g. "4.0"
    public static let systemVersion: String = ""//GDevice.current.systemVersion
    // e.g. "iOS"
    public static let systemName: String = ""//GDevice.current.systemName
    // e.g. "iPhone", @"iPod touch"
    public static let model: String = ""//GDevice.current.model
    // e.g. "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
    public static let UUIDString: String = ""//GDevice.current.identifierForVendor?.uuidString ?? ""
    
}

open class AppContext: NSObject {
    
    public let configurationPath = Bundle.main.path(forResource: "AppConfiguration", ofType: "plist")
    open lazy var configurations: NSDictionary = {
        guard let path = self.configurationPath else { return [:] }
        let configurations =  NSDictionary(contentsOfFile: path) ?? [:]
        return configurations
    }()
    
    @objc public lazy var environmentCode: Int = {
        let code = self.configurations["environmentCode"] as? Int ?? Int.max
        return code
    }()

    public static func fetchAuthorizationToken() -> String {
        return ""
    }
    
    public static var timestamp: TimeInterval {
        get {
            var time = Date().timeIntervalSince1970*1000
            time.round(.up)
            return time//String(format: "%.f", time)
        }
    }
        
    public static var appVersion: String {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ??  "1.0.0"
        }
    }
    
    public static var appBuild: String {
        get {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ??  "1.0.0"
        }
    }
    
    public static var appName: String? {
        get {
            var temp = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            temp = temp?.replacingOccurrences(of: "-", with: "_")
            return temp
        }
    }
    
    public static var clzPrefix: String? {
        get {
            var clz: String? = nil
            
            if appName != nil && !appName!.isEmpty  {
                clz = appName! + "."
            }
            return clz
        }
    }
    
    open func appStarted() -> Void {
    }
    
    open func appEnded() -> Void {
    }
    
//    open func registerAPNs() -> Void {
////        if #available(iOS 10.0, *) {
////            let center = UNUserNotificationCenter.current()
////            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { [weak self] (granted, error) in
////                if !granted {
////                    self?.showToast(message: "请开启推送功能否则无法收到推送通知")
////                }
////            })
////
////        } else {
////            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
////            UIApplication.shared.registerUserNotificationSettings(settings)
////        }
////        UIApplication.shared.registerForRemoteNotifications()
//
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
//
//            })
//
//        } else
//            if #available(iOS 8.0, *) {
//                cApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil))
//
//            } else {
//                cApplication.shared.registerForRemoteNotifications(matching: [.alert, .sound, .badge])
//        }
//
//        UIApplication.shared.registerForRemoteNotifications()
//
//    }
    
}

extension NSNotification.Name {
    public static let BDDidLoginNotificaton = NSNotification.Name(rawValue: "BDDidLoginNotificaton")
    public static let BDCancelLoginNotification = NSNotification.Name(rawValue: "BDCancelLoginNotification")
    public static let BDDidSignOutNotificaton = NSNotification.Name(rawValue: "BDDidSignOutNotificaton")
    public static let BDAutoLoginSuccessNotification = NSNotification.Name(rawValue: "BDAutoLoginSuccessNotification")
    public static let BDAutoLoginFailNotification = NSNotification.Name(rawValue: "BDAutoLoginFailNotification")
}



