//
//  BDNetworkCacheManager.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/19.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import UIKit

class BDNetworkCacheManager: NSObject {

    static let sharedInstance = BDNetworkCacheManager()
    var cache = NSCache<AnyObject, AnyObject>()

    override init() {
        super.init()
        cache.countLimit = BDNetworkingConfiguration.cacheCountLimit
        cache.name = "BDNetworkCache"
    }
    
    func transformUrlParamsToSortedArray(params: [String: Any], isForSignature: Bool = false) -> [String] {
        var result: [String] = []
        for (key, value) in params {
            var newValue = value as? String
    
            if newValue == nil {
              newValue = String(describing: value)
            }
            if !isForSignature {
                newValue = newValue?.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&;=+$,/?%#[]"))
            }
            if newValue != nil && !newValue!.isEmpty {
                result.append("\(key)=\(newValue!)")
            }
        }
        result = result.sorted()
        return result
    }
    
    func transformUrlParamsToString(params: [String: Any], isForSignature: Bool = false) -> String {
        let sortedArray = transformUrlParamsToSortedArray(params: params, isForSignature: isForSignature)
        var paramString = ""
        
        for temp in sortedArray {
            let separator = temp.isEmpty ? "" : "&"
            paramString += separator
            paramString += temp
        }
        
        return paramString
    }
    
    // MARK: - save
    func saveCache(data: Data, key: AnyObject) -> Void {
        var cachedObject = cache.object(forKey: key)
        if cachedObject == nil {
            cachedObject = BDNetworkCache(data: data)
        }
        cache.setObject(cachedObject!, forKey: key)
    }
    
    func saveCache(
        data: Data,
        serviceIdentifier: String,
        relativeUrl: String,
        requestParams: [String: Any])
        -> Void {
            let key = (serviceIdentifier + relativeUrl + transformUrlParamsToString(params: requestParams)) as AnyObject
            
            saveCache(data: data, key: key)
    }
    
    // MARK: - fetch
    func fetchCache(key: AnyObject) -> Data? {
        let cachedObject = cache.object(forKey: key) as? BDNetworkCache
        if cachedObject == nil || cachedObject!.isOutOfDate || cachedObject!.isEmpty {
            return nil
        } else {
            return cachedObject!.data
        }
    }
    
    func fetchCache(
        serviceIdentifier: String,
        relativeUrl: String,
        requestParams: [String: Any])
        -> Data? {
            let key = (serviceIdentifier + relativeUrl + transformUrlParamsToString(params: requestParams)) as AnyObject
            return fetchCache(key: key)
    }
    
    // MARK: - delete
    func clean() -> Void {
        cache.removeAllObjects()
    }
    
    func deleteCache(
        serviceIdentifier: String,
        relativeUrl: String,
        requestParams: [String: Any])
        -> Void {
            let key = (serviceIdentifier + relativeUrl + transformUrlParamsToString(params: requestParams)) as AnyObject
            cache.removeObject(forKey: key)
    }
    
    
}
