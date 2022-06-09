//
//  AuthenticationService+Model.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//

import Foundation

public extension AuthenticationService { enum Model {} }

public extension AuthenticationService.Model {

    struct AccessToken: Codable, Hashable {
        private enum CodingKeys: String, CodingKey { case token = "access_token" }
        public let token: String
    }

    struct AuthenticationCode: Codable, Hashable {
        private enum CodingKeys: String, CodingKey { case code = "code" }
        public let code: String
    }

    struct OAuthTokenModel: Codable, Hashable {
        private enum CodingKeys: String, CodingKey { case token = "oauth_token" }
        public let token: String
    }
}
