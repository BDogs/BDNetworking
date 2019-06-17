//
//  Dictionary+Add.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/22.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Foundation

internal extension Dictionary {
    
    
    func json() -> String? {
        var paramJson: String?
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            paramJson = String(data: data, encoding: .utf8) ?? ""
        }
        return paramJson
    }
    
}
