//
//  ValidationError.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import Foundation

enum ValidationError: LocalizedError {
    case missingField
    
    var errorDescription: String? {
        switch self {
        case .missingField:
            return Constants.missingFieldsTitle
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .missingField:
            return Constants.missingFieldsMessage
        }
    }
    
    struct Constants {
        static let missingFieldsTitle = "Missing Fields"
        static let missingFieldsMessage = "Please provide all the information."
    }
}
