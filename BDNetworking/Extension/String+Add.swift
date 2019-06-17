//
//  String+Add.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/28.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Foundation

internal extension String {
    
    func fileName(separator: String?) -> String {
        guard let separator = separator else { return "" }
        var temp = components(separatedBy: "\(separator)")
        temp.removeAll { (element) -> Bool in
            return element == "/"
        }
        for i in 0..<temp.count {
            let element = temp[i]
            guard element.count > 0 else {
                continue
            }
            let prefix = element.prefix(1)
            let new = prefix.capitalized
            temp[i] = element.replacingCharacters(in: element.startIndex..<element.index(element.startIndex, offsetBy: 1), with: new)
        }
        
        return temp.joined()
    }
    
    func lowercasePrefix(maxLength: Int = 1) -> String {
        guard count > 0 else {
            return ""
        }
        let prefix = self.prefix(maxLength)
        let new = prefix.lowercased()
        let offset = count > maxLength ? maxLength : count-1
        return self.replacingCharacters(in: startIndex..<index(startIndex, offsetBy: offset), with: new)
    }

}
