//
//

import UIKit
import BDNetworking

public class PLUserGetUserDetailAPIDataReformer: NSObject {
    
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
        
        public static let contactAddress: InfoKey = InfoKey(rawValue: "contact_address")
        public static let addressId: InfoKey = InfoKey(rawValue: "address_id")
        public static let createdate: InfoKey = InfoKey(rawValue: "createdate")
        public static let patientType: InfoKey = InfoKey(rawValue: "patient_type")
        public static let patientDisease: InfoKey = InfoKey(rawValue: "patient_disease")
        public static let patientBirthday: InfoKey = InfoKey(rawValue: "patient_birthday")
        public static let contactCity: InfoKey = InfoKey(rawValue: "contact_city")
        public static let patientIdtype: InfoKey = InfoKey(rawValue: "patient_idtype")
        public static let patientHealthNote: InfoKey = InfoKey(rawValue: "patient_health_note")
        public static let patientName: InfoKey = InfoKey(rawValue: "patient_name")
        public static let patientJob: InfoKey = InfoKey(rawValue: "patient_job")
        public static let contactProvince: InfoKey = InfoKey(rawValue: "contact_province")
        public static let otherDiseaseHistory: InfoKey = InfoKey(rawValue: "other_disease_history")
        public static let contactTel: InfoKey = InfoKey(rawValue: "contact_tel")
        public static let patientNation: InfoKey = InfoKey(rawValue: "patient_nation")
        public static let patientIdcardnum: InfoKey = InfoKey(rawValue: "patient_idcardnum")
        public static let patientWeight: InfoKey = InfoKey(rawValue: "patient_weight")
        public static let patientTel: InfoKey = InfoKey(rawValue: "patient_tel")
        public static let updatedate: InfoKey = InfoKey(rawValue: "updatedate")
        public static let patientEdu: InfoKey = InfoKey(rawValue: "patient_edu")
        public static let recordUrl: InfoKey = InfoKey(rawValue: "record_url")
        public static let currentDescribe: InfoKey = InfoKey(rawValue: "current_describe")
        public static let createuserid: InfoKey = InfoKey(rawValue: "createuserid")
        public static let patientHeight: InfoKey = InfoKey(rawValue: "patient_height")
        public static let patientNameab: InfoKey = InfoKey(rawValue: "patient_nameab")
        public static let contactPostcode: InfoKey = InfoKey(rawValue: "contact_postcode")
        public static let contactCountry: InfoKey = InfoKey(rawValue: "contact_country")
        public static let diseaseDate: InfoKey = InfoKey(rawValue: "disease_date")
        public static let medicationHistory: InfoKey = InfoKey(rawValue: "medication_history")
        public static let patientSex: InfoKey = InfoKey(rawValue: "patient_sex")
        public static let patientRelation: InfoKey = InfoKey(rawValue: "patient_relation")
        public static let patientId: InfoKey = InfoKey(rawValue: "patient_id")
        public static let clinicOffice: InfoKey = InfoKey(rawValue: "clinic_office")
        public static let applyedCard: InfoKey = InfoKey(rawValue: "applyed_card")
        public static let clinicHospital: InfoKey = InfoKey(rawValue: "clinic_hospital")
        public static let contactRelation: InfoKey = InfoKey(rawValue: "contact_relation")
        public static let contactPerson: InfoKey = InfoKey(rawValue: "contact_person")
        public static let updateuserid: InfoKey = InfoKey(rawValue: "updateuserid")

    }
}

extension PLUserGetUserDetailAPIDataReformer: BDAPIManagerDataReformer {
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
