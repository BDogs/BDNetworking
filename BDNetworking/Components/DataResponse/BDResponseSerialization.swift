//
//  BDResponseSerialization.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/14.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation
private let emptyDataStatusCodes: Set<Int> = [204, 205]
class BDResponseSerialization: NSObject {

    public static func serializeResponseJSON(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> BDResult<Any>
    {
        guard let response = response else {
            return .failure(BDError.responseNil)
        }
        
        guard error == nil else { return .failure(error!) }
        if emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(BDError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(json)
        } catch {
            return .failure(BDError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
    
    
}
