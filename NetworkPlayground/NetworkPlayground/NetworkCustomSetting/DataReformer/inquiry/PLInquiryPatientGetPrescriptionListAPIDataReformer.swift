//
//

import UIKit
import BDNetworking

public class PLInquiryPatientGetPrescriptionListAPIDataReformer: NSObject {
    
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
        
        public static let diseasesName: InfoKey = InfoKey(rawValue: "diseases_name")
        public static let photoUrl: InfoKey = InfoKey(rawValue: "photo_url")
        public static let status: InfoKey = InfoKey(rawValue: "status")
        public static let statusName: InfoKey = InfoKey(rawValue: "status_name")
        public static let doctorName: InfoKey = InfoKey(rawValue: "doctor_name")
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let id: InfoKey = InfoKey(rawValue: "id")

    }
}

extension PLInquiryPatientGetPrescriptionListAPIDataReformer: BDAPIManagerDataReformer {
    @objc public func reformData(manager: BDAPIBaseManager, data: Any?) -> Any {
        var result: [InfoKey: Any] = [:]
        guard let dic = data as? [String: Any] else { return [:] }
        for element in dic.keys {
            let key = InfoKey(rawValue: element)
            result[key] = dic[element]
        }
       
        var reformedData: [[InfoKey: Any]] = []
        let isSuccess = dic["success"] as? Bool ?? false
        guard isSuccess else {
            result[.reformedData] = reformedData
            return result
        }
        guard let source = dic["data"] as? [[String: Any]] else {
            result[.reformedData] = reformedData
            return result }

        for i in 0..<source.count {
            var temp = source[i]
            reformedData.append([:])

            for element in temp.keys {
                let key = InfoKey(rawValue: element)
                reformedData[i][key] = temp[element]
            }
        }
        result[.reformedData] = reformedData
        return result

    }
}
