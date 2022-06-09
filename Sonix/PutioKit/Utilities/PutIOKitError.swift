//
//  PutIOKitError.swift
//  PutioKit
//  
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation

public enum PutIOKitError: LocalizedError {

    case offline
    case unauthorised
    case requestFailed(statusCode: Int)
    case uploadTaskFailed
    case invalidParameters
    case invalidURL
    case parsingFailed
    case invalidResponse(String)
    case failedToDownloadContentOfFile

    static func isOffline(error: Error) -> Bool {
        (error as NSError).code == -1009
    }
    
    public var errorDescription: String? {
        return Constants.sorry
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .offline:
            return Constants.offline
        case .unauthorised:
            return Constants.unauthorised
        case .requestFailed(let statusCode):
            return String(format: Constants.requestFailed, statusCode)
        case .uploadTaskFailed:
            return Constants.uploadFailed
        case .invalidParameters:
            return Constants.invalidParameters
        case .invalidURL:
            return Constants.invalidURL
        case .parsingFailed:
            return Constants.parsingFailed
        case .invalidResponse(let string):
            return string
        case .failedToDownloadContentOfFile:
            return Constants.downloadFailed
        }
    }
    
    struct Constants {
        static let sorry = "Sorry"
        static let offline = "It seems the user is offline."
        static let unauthorised = "The user session has expired."
        static let requestFailed = "The request has failed with status code %d. Please try again later."
        static let uploadFailed = "The upload process failed."
        static let invalidParameters = "Request parameters are invalid."
        static let invalidURL = "Provided url is invalid."
        static let parsingFailed = "Response parsing failed."
        static let downloadFailed = "Downloading failed at the moment. Please try again later."
    }
}


public extension PutIOKitError {

    enum Authentication: Error {
        case invalidUsername(_ username: String)
        case invalidPassword(_ password: String)
        case authenticateFailed(_ error: Error)
    }

    enum Files: Error {
        case invalidMultipartData
    }

    enum Share: Error {
        public static func hasExceededLimit(_ error: Error) -> Bool {
            guard let errorModel = error as? ErrorModel, errorModel.message == "PUBLIC_SHARE_EXCEEDED_LIMIT" else { return false }
            return true
        }
    }
}
