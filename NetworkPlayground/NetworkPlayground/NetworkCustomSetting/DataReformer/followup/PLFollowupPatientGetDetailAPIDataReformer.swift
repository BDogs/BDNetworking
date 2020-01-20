//
//

import UIKit
import BDNetworking

public class PLFollowupPatientGetDetailAPIDataReformer: NSObject {
    
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
        
        public static let patientId: InfoKey = InfoKey(rawValue: "patient_id")
        public static let endDate: InfoKey = InfoKey(rawValue: "end_date")
        public static let office: InfoKey = InfoKey(rawValue: "office")
        public static let id: InfoKey = InfoKey(rawValue: "id")
        public static let createuserid: InfoKey = InfoKey(rawValue: "createuserid")
        public static let position: InfoKey = InfoKey(rawValue: "position")
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let note: InfoKey = InfoKey(rawValue: "note")
        public static let hospitalName: InfoKey = InfoKey(rawValue: "hospital_name")
        public static let subtaskCount: InfoKey = InfoKey(rawValue: "subtask_count")
        public static let userName: InfoKey = InfoKey(rawValue: "user_name")
        public static let taskName: InfoKey = InfoKey(rawValue: "task_name")
        public static let taskNameCode: InfoKey = InfoKey(rawValue: "task_name_code")
        public static let status: InfoKey = InfoKey(rawValue: "status")
        public static let frequencyCode: InfoKey = InfoKey(rawValue: "frequency_code")
        public static let updatedate: InfoKey = InfoKey(rawValue: "updatedate")
        public static let doctorId: InfoKey = InfoKey(rawValue: "doctor_id")
        public static let startDate: InfoKey = InfoKey(rawValue: "start_date")
        public static let taskType: InfoKey = InfoKey(rawValue: "task_type")
        public static let taskProject: InfoKey = InfoKey(rawValue: "task_project")
        public static let doctorFaceUrl: InfoKey = InfoKey(rawValue: "doctor_face_url")
        public static let updateuserid: InfoKey = InfoKey(rawValue: "updateuserid")

    }
}

extension PLFollowupPatientGetDetailAPIDataReformer: BDAPIManagerDataReformer {
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
