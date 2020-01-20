//
//

import UIKit
import BDNetworking

public class PLInquiryDoctorGetServicesDetailAPIDataReformer: NSObject {
    
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
        
        public static let updateuserid: InfoKey = InfoKey(rawValue: "updateuserid")
        public static let note: InfoKey = InfoKey(rawValue: "note")
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let status: InfoKey = InfoKey(rawValue: "status")
        public static let updatedate: InfoKey = InfoKey(rawValue: "updatedate")
        public static let telephone: InfoKey = InfoKey(rawValue: "telephone")
        public static let refuseReason: InfoKey = InfoKey(rawValue: "refuse_reason")
        public static let sex: InfoKey = InfoKey(rawValue: "sex")
        public static let doctorId: InfoKey = InfoKey(rawValue: "doctor_id")
        public static let id: InfoKey = InfoKey(rawValue: "id")
        public static let name: InfoKey = InfoKey(rawValue: "name")
        public static let outpatientRecord: InfoKey = InfoKey(rawValue: "outpatient_record")
        public static let createuserid: InfoKey = InfoKey(rawValue: "createuserid")
        public static let idtype: InfoKey = InfoKey(rawValue: "idtype")
        public static let outpatientDate: InfoKey = InfoKey(rawValue: "outpatient_date")
        public static let idcard: InfoKey = InfoKey(rawValue: "idcard")
        public static let patientId: InfoKey = InfoKey(rawValue: "patient_id")
        public static let userFaceUrl: InfoKey = InfoKey(rawValue: "user_face_url")
        public static let birthday: InfoKey = InfoKey(rawValue: "birthday")

    }
}

extension PLInquiryDoctorGetServicesDetailAPIDataReformer: BDAPIManagerDataReformer {
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
