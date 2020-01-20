//
//  PLFollowupTaskListDataReformer.swift
//  PinsLife
//
//  Created by 诸葛游 on 2018/8/9.
//Copyright © 2018年 品驰医疗. All rights reserved.
//

//import UIKit

//import BDNetworking
//import PLCommonModule
import Cocoa

public class PLFollowupTaskListDataReformer: NSObject {
    
    public struct InfoKey: Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let success: InfoKey = InfoKey(rawValue: "success")
        public static let data: InfoKey = InfoKey(rawValue: "data")
        public static let message: InfoKey = InfoKey(rawValue: "message")
        public static let statusCode: InfoKey = InfoKey(rawValue: "status_code")
        public static let serverTime: InfoKey = InfoKey(rawValue: "server_time")
        public static let errorCode: InfoKey = InfoKey(rawValue: "error_code")
        public static let reformedData: InfoKey = InfoKey(rawValue: "kreformedData")

    }
    
    static let kIsSuccesss = "success" // bool

    static let kScore = "score"
    static let kScoreDetailJson = "score_detail"
    static let kId = "id"
    static let kPatientId = "patient_id"
    static let kQuestionModule = "question_module"
    static let kQuestionLabel = "question_label"
    static let kNote = "note"
    static let kCreatedateTimestamp = "createdate"
    
    public static let kScoreDetails = "kScoreDetails"
    public static let KCreateDateDescription = "KCreateDateDescription"
    public static let kType = "kType"
//    public static let kModule = "module"

}

extension PLFollowupTaskListDataReformer: BDAPIManagerDataReformer {
    @objc public func reformData(manager: BDAPIBaseManager, data: Any?) -> Any {
        var result: [InfoKey: Any] = [:]
        guard let dic = data as? [String: Any] else { return [:] }
        for element in dic.keys {
            let key = InfoKey(rawValue: element)
            result[key] = dic[element]
        }
        
        var reformedData: [InfoKey: Any] = [:]
        guard let source = dic["data"] as? [String: Any] else {
            result[.reformedData] = reformedData
            return result }
    
        for element in source.keys {
            let key = InfoKey(rawValue: element)
            reformedData[key] = source[element]
        }
        
        result[.reformedData] = reformedData
        return result
    }
}
