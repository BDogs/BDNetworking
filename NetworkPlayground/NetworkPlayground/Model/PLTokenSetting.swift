//
//  PLTokenSetting.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/19.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Foundation


struct PLUserInfo: Codable {
    let userName: String
    let vCode: String
    var token: String?
//    var apiManagerName: String
    
    
    
    init(userName: String, vCode: String, token: String?) {
        self.userName = userName
        self.vCode = vCode
//        self.apiManagerName = apiManagerName
        self.token = token
    }

    enum CodingKeys: CodingKey {
        case userName
        case vCode
        case token
//        case apiManagerName
    }


    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(vCode, forKey: .vCode)
//        try container.encode(apiManagerName, forKey: .apiManagerName)
        try container.encode(token, forKey: .token)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        vCode = try container.decode(String.self, forKey: .vCode)
//        apiManagerName = try container.decode(String.self, forKey: .apiManagerName)
        token = try? container.decode(String.self, forKey: .token)
    }
    
    
    static let relativePath = "/PLUser"

    public static func save(info: (apiManagerName: String, setting: [Int: PLUserInfo])) -> Void {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        var filePath = documentPath+PLUserInfo.relativePath
        let fmanager = FileManager.default
        if !fmanager.fileExists(atPath: filePath) {
            try? fmanager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }

        var records = fetch()
        records[info.apiManagerName] = info.setting
        
        let encocder = JSONEncoder()
        do {
            let encodedData = try encocder.encode(records)
            if let json = String(data: encodedData, encoding: .utf8) {
                filePath += "/PLUserInfo.log"
                print(filePath)
                try? json.write(toFile: filePath, atomically: true, encoding: .utf8)
            }
            
        } catch { }
    }
    
    public static func fetch() -> [String: [Int: PLUserInfo]] {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return [:] }
        let filePath = documentPath+PLUserInfo.relativePath+"/PLUserInfo.log"
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            let decoded = try? JSONDecoder().decode([String: [Int: PLUserInfo]].self, from: data)
            
            return decoded ?? [:]
        }
        return [:]
    }

    
}
