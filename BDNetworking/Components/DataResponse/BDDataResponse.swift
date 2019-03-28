//
//  BDDataResponse.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/14.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import UIKit

public class BDDataResponse<Value>: NSObject {
    ///
    public let request: URLRequest?
    ///
    public let response: HTTPURLResponse?
    ///
    public let data: Data?
    ///
    public let result: BDResult<Value>
    /// request 完成周期的时间轴
    ///
    public let requestId: Int
    ///
    public var isCache = false
    
    public init(
        request: URLRequest?,
        requestId: Int = 0,
        response: HTTPURLResponse?,
        data: Data?,
        result: BDResult<Value>,
        metrics: AnyObject? = nil) {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.requestId = requestId
    }
    
}
