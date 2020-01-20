//
//

import UIKit
import BDNetworking

public class PLInquiryGetIntroduceDetailAPIDataReformer: NSObject {
    
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
        
        public static let diseaseCode: InfoKey = InfoKey(rawValue: "disease_code")
        public static let city: InfoKey = InfoKey(rawValue: "city")
        public static let age: InfoKey = InfoKey(rawValue: "age")
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let hospitalName: InfoKey = InfoKey(rawValue: "hospital_name")
        public static let sex: InfoKey = InfoKey(rawValue: "sex")
        public static let inquiryContent: InfoKey = InfoKey(rawValue: "inquiry_content")
        public static let birthday: InfoKey = InfoKey(rawValue: "birthday")
        public static let name: InfoKey = InfoKey(rawValue: "name")
        public static let medicalSheet: InfoKey = InfoKey(rawValue: "medical_sheet")
        public static let diseaseTime: InfoKey = InfoKey(rawValue: "disease_time")
        public static let province: InfoKey = InfoKey(rawValue: "province")
        public static let heavyDisease: InfoKey = InfoKey(rawValue: "heavy_disease")
        public static let heavyDiseaseDesc: InfoKey = InfoKey(rawValue: "heavy_disease_desc")
        public static let inquiryId: InfoKey = InfoKey(rawValue: "inquiry_id")
        public static let relation: InfoKey = InfoKey(rawValue: "relation")
        public static let telephone: InfoKey = InfoKey(rawValue: "telephone")
        public static let medicines: InfoKey = InfoKey(rawValue: "medicines")
        public static let office: InfoKey = InfoKey(rawValue: "office")
        public static let diseaseName: InfoKey = InfoKey(rawValue: "disease_name")

    }
}

extension PLInquiryGetIntroduceDetailAPIDataReformer: BDAPIManagerDataReformer {
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
