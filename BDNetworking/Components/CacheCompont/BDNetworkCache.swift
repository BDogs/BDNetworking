//
//  BDNetworkCache.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/19.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation

class BDNetworkCache: NSObject {

    private(set) var data: Data?
    private(set) var lastUpdateDate: Date?
    
    var isOutOfDate: Bool {
        get {
            let timeInterval = Date().timeIntervalSince(self.lastUpdateDate!)
            return timeInterval > BDNetworkingConfiguration.cacheOutdateTimeSeconds
        }
    }
    
    var isEmpty: Bool {
        get {
            return self.data == nil || (self.data != nil && self.data!.count <= 0)
        }
    }
    
    init(data: Data) {
        super.init()
        updateData(data: data)
    }
    
    func updateData(data: Data) -> Void {
        self.data = data
        self.lastUpdateDate = Date(timeIntervalSinceNow: 0)
    }
    
}
