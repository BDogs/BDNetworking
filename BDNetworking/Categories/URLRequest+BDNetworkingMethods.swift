//
//  URLRequest+BDNetworkingMethods.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/13.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

//private var kRequestParams: Void?
//private var kService: Void?


//extension URLRequest {
//    
//    struct AssociatedKeys {
//     
//        static var kRequestParams: String = "associatedKeys_requestParams"
//        static var kService: String = "associatedKeys_service"
//        
//        
////        static let kRequestParams = UnsafeRawPointer.init(bitPattern: "associatedKeys_requestParams".hashValue)
////        static let kService = UnsafeRawPointer.init(bitPattern: "associatedKeys_service".hashValue)
//    }
//    
//    var requestParams: [String: Any]? {
//        get {
//           return objc_getAssociatedObject(self, AssociatedKeys.kRequestParams) as? [String : String]
//        }
//        set {
//            objc_setAssociatedObject(self, AssociatedKeys.kRequestParams, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    var service: BDService? {
//        get {
//            print(AssociatedKeys.kService)
////            print(objc_getAssociatedObject(self, &AssociatedKeys.kService))
//            return objc_getAssociatedObject(self, &AssociatedKeys.kService) as? BDService
//        }
//        set {
//            
//            let theNew = (newValue as! BDService)
//            
//            objc_setAssociatedObject(self, &AssociatedKeys.kService, theNew, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//}
