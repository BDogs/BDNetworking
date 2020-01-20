//
//

import Foundation

public class PLUserInfoAPIDataReformer: NSObject {
    
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
        
        public static let contactCity: InfoKey = InfoKey(rawValue: "contact_city")
        public static let userName: InfoKey = InfoKey(rawValue: "user_name")
        public static let contactProvince: InfoKey = InfoKey(rawValue: "contact_province")
        public static let patientIdcardnum: InfoKey = InfoKey(rawValue: "patient_idcardnum")
        public static let userQrcodeUrl: InfoKey = InfoKey(rawValue: "user_qrcode_url")
        public static let contactPostcode: InfoKey = InfoKey(rawValue: "contact_postcode")
        public static let userTelephone: InfoKey = InfoKey(rawValue: "user_telephone")
        public static let contactRelation: InfoKey = InfoKey(rawValue: "contact_relation")
        public static let userId: InfoKey = InfoKey(rawValue: "user_id")
        public static let appointmentId: InfoKey = InfoKey(rawValue: "appointment_id")
        public static let contactTel: InfoKey = InfoKey(rawValue: "contact_tel")
        public static let applyedCardStatus: InfoKey = InfoKey(rawValue: "applyed_card_status")
        public static let patientName: InfoKey = InfoKey(rawValue: "patient_name")
        public static let openid: InfoKey = InfoKey(rawValue: "openid")
        public static let unionid: InfoKey = InfoKey(rawValue: "unionid")
        public static let patientWeight: InfoKey = InfoKey(rawValue: "patient_weight")
        public static let contactPerson: InfoKey = InfoKey(rawValue: "contact_person")
        public static let patientBirthday: InfoKey = InfoKey(rawValue: "patient_birthday")
        public static let userFaceUrl: InfoKey = InfoKey(rawValue: "user_face_url")
        public static let contactAddress: InfoKey = InfoKey(rawValue: "contact_address")
        public static let token: InfoKey = InfoKey(rawValue: "token")
        public static let patientType: InfoKey = InfoKey(rawValue: "patient_type")
        public static let userRealId: InfoKey = InfoKey(rawValue: "user_real_id")
        public static let contactCountry: InfoKey = InfoKey(rawValue: "contact_country")
        public static let patientSex: InfoKey = InfoKey(rawValue: "patient_sex")
        public static let patientHealthNote: InfoKey = InfoKey(rawValue: "patient_health_note")
        public static let imId: InfoKey = InfoKey(rawValue: "im_id")
        public static let patientIdtype: InfoKey = InfoKey(rawValue: "patient_idtype")
        public static let patientHeight: InfoKey = InfoKey(rawValue: "patient_height")

    }
}

extension PLUserInfoAPIDataReformer: BDAPIManagerDataReformer {
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
