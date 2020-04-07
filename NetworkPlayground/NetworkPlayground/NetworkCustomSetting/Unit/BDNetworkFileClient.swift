//
//  BDNetworkFileClient.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/28.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Foundation

struct APIInfo {
    let relativeUrl: String

    let service: BDService
    
    let requestType: BDAPIRequestType
    

}

enum BDNetworkFile {
    case apiManager
    
    case dataReformer
    
    
    var templeFilePath: String {
        get {
            switch self {
            case .apiManager:
                return "BDAPIBaseManagerSwift/___FILEBASENAME___.swift"
            case .dataReformer:
                return "BDAPIManagerDataReformerSwift/___FILEBASENAME___.swift"
            }
        }
    }
    
    
    var floderPath: String {
        get {
            var path = "NetworkPlayground/NetworkPlayground/NetworkCustomSetting/"
            switch self {
            case .apiManager:
                path += "APIManger"
            case .dataReformer:
                path += "DataReformer"
            }
            return path
        }
    }
    
}

class BDNetworkFileClient {
    static var projectPath = "/Users/zhugeyou/Desktop/MyGitHub/BDNetworking/"
    
    class func fetchFileContent(type: BDNetworkFile) -> String {
        
        let content: String
        let path = "\(projectPath)NetworkPlayground/NetworkPlayground/NetworkCustomSetting/FileTemple/\(type.templeFilePath)"
        
        do {
            content = try String(contentsOfFile: path)
        } catch let error {
            content = "error: \(error.localizedDescription)"
        }
        return content
    }
    

    class func save(type: BDNetworkFile,
                    content: String,
                    fileName: String,
                    floder: String?) -> Bool {
        guard !content.isEmpty else {
            return false
        }
        var path = "\(projectPath)\(type.floderPath)"
        if let floder = floder {
            path += "/\(floder)"
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: path) {
            do {
                try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch { }
        }
        
        path += "/\(fileName).swift"
        do {
            try content.write(toFile: path, atomically: true, encoding: .utf8)
            return true
        } catch _ {
            return false
        }
    }
    
}
