//
//  BDAPIBaseManager+Refresh.swift
//  BDNetworking
//
//  Created by 诸葛游 on 2018/1/5.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation
import Unit

public protocol BDAPIBaseManagerRefresh {
    var timestamp: TimeInterval? { get set }
    var isRefresh: Bool { get set }
    
    func loadNextPage() -> Void
    
    func loadFirstPage() -> Void
}


open class BDAPIRefreshManager: BDAPIBaseManager, BDAPIBaseManagerRefresh {
    public var timestamp: TimeInterval?
    
    public var isRefresh: Bool = true
    
    @objc open func loadNextPage() -> Void {
        isRefresh = false
        if timestamp == nil {
            self.delegate?.managerCallAPIDidFailed(manager: self)
            return
        }
        
        if self.isLoading{
            self.delegate?.managerCallAPIDidFailed(manager: self)
            return
        }
        let _ = self.loadData()
    }
    
    @objc open func loadFirstPage() -> Void {
        isRefresh = true
        if self.isLoading {
            self.delegate?.managerCallAPIDidFailed(manager: self)
            return
        }
        
        timestamp = AppContext.timestamp
        let _ = self.loadData()
    }
    
}
