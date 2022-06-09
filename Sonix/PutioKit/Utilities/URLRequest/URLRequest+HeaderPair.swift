//
//  URLRequest+HeaderPair.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//

import Foundation

extension URLRequest { struct HeaderPair { public let name: String, value: String } }

extension URLRequest.HeaderPair {

    static var contentTypeFormURLEncoded = URLRequest.HeaderPair(name: "Content-Type", value: "application/x-www-form-urlencoded")
    static var contentTypeJSON = URLRequest.HeaderPair(name: "Content-Type", value: "application/json")
    static var acceptSubrip = URLRequest.HeaderPair(name: "Accept", value: "application/x-subrip")
    static var acceptVTT = URLRequest.HeaderPair(name: "Accept", value: "text/vtt")

    static func basicAuthorization(username: String, password: String) -> URLRequest.HeaderPair? {
        guard let encoded = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else { return nil }
        return URLRequest.HeaderPair(name: "Authorization", value: "Basic \(encoded)")
    }

    static func bearerAuthorization(credentialsStore: CredentialsStoring) -> URLRequest.HeaderPair? {
        guard let token = credentialsStore.accessToken else { return nil }
        return URLRequest.HeaderPair(name: "Authorization", value: "Bearer \(token)")
    }

    static func contentTypeMultipart(boundary: String) -> URLRequest.HeaderPair {
        return URLRequest.HeaderPair(name: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
    }
}
