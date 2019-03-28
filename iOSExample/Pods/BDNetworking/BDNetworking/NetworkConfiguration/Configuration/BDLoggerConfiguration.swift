//
//  BDLoggerConfiguration.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKitb
import Foundation
class BDLoggerConfiguration: NSObject {
    /** 渠道ID */
    private(set) var channelID: String?
    /** app标志 */
    private(set) var appKey: String?
    /** app名字 */
    private(set) var logAppName: String?
    /** 服务名 */
    private(set) var serviceType: String?
    /** 记录log用到的webapi方法名 */
    private(set) var sendLogMethod: String?
    /** 记录action用到的webapi方法名 */
    private(set) var sendActionMethod: String?
    /** 发送log时使用的key */
    private(set) var sendLogKey: String?
    /** 发送Action记录时使用的key */
    private(set) var sendActionKey: String?
    
    public func configWithAppType(appType: BDAppType) {
        switch appType {
        case .xxx:
            self.channelID = "xxx"
            self.appKey = "xxxxxx"
            self.serviceType = "xxxxx"
            self.sendLogMethod = "xxxx"
            self.sendActionMethod = "xxxxxx"
            self.sendLogKey = "xxxxx"
            self.sendActionKey = "xxxx"
            break
        }
    }
}
