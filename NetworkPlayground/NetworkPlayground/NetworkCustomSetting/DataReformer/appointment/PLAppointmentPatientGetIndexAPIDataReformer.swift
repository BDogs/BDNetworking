//
//

import UIKit
import BDNetworking

public class PLAppointmentPatientGetIndexAPIDataReformer: NSObject {
    
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
        
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let id: InfoKey = InfoKey(rawValue: "id")
        public static let appointmentState: InfoKey = InfoKey(rawValue: "appointment_state")
        public static let doctorName: InfoKey = InfoKey(rawValue: "doctor_name")
        public static let more: InfoKey = InfoKey(rawValue: "more")
        public static let doctorId: InfoKey = InfoKey(rawValue: "doctor_id")
        public static let appointmentTime: InfoKey = InfoKey(rawValue: "appointment_time")
        public static let statusName: InfoKey = InfoKey(rawValue: "status_name")
        public static let appointmentDate: InfoKey = InfoKey(rawValue: "appointment_date")
        public static let note: InfoKey = InfoKey(rawValue: "note")

    }
}

extension PLAppointmentPatientGetIndexAPIDataReformer: BDAPIManagerDataReformer {
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
