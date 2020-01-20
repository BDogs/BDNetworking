//
//  BDError.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/14.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

public enum BDError: Error {
    
    
    
    /// The underlying reason the response serialization error occurred.
    ///
    /// - inputDataNil:                    The server response contained no data.
    /// - inputDataNilOrZeroLength:        The server response contained no data or the data was zero length.
    /// - inputFileNil:                    The file containing the server response did not exist.
    /// - inputFileReadFailed:             The file containing the server response could not be read.
    /// - stringSerializationFailed:       String serialization failed using the provided `String.Encoding`.
    /// - jsonSerializationFailed:         JSON serialization failed with an underlying system error.
    /// - propertyListSerializationFailed: Property list serialization failed with an underlying system error.
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }
    
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
    case networkIsNotReachable
    case validateFailed(reason: ValidateFailureReson)
    case generateURLRequestFailed
    case  generateServiceFailed
    case responseNil
    
    public enum ValidateFailureReson {
        case fetchedRawDataValidateFailed
        case requestParamsValidateFailed
    }
    
    
    
    
    
    
    
    
}
