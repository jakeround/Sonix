//
//  AuthenticationService.swift
//  PutioKit
//  
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation
import Combine

public struct AuthenticationService {

    public typealias AuthenticateCompletion = (Result<AuthenticationService.Model.AccessToken, Error>) -> Void
    public typealias FetchAuthenticationCodeCompletion = (Result<AuthenticationService.Model.AuthenticationCode, Error>) -> Void
    public typealias CheckMatchedAuthenticationCodeCompletion = (Result<AuthenticationService.Model.OAuthTokenModel, Error>) -> Void

    private let clientModel: ApiClientModel
    private let networkHandler: NetworkHandling

    public init(clientModel: ApiClientModel,
         networkHandler: NetworkHandling) {

        self.clientModel = clientModel
        self.networkHandler = networkHandler
    }
}

// MARK: - Implementation

public extension AuthenticationService {

    func authenticate(
        username: String,
        password: String,
        completion: @escaping AuthenticateCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("oauth2")
            .appendingPathComponent("authorizations")
            .appendingPathComponent("clients")
            .appendingPathComponent(clientModel.id)

        let queryItems = [
            "client_secret": clientModel.secret,
            "client_name": clientModel.name
        ]

        let headers: [URLRequest.HeaderPair] = [
            .contentTypeFormURLEncoded,
            .basicAuthorization(username: username, password: password)
        ].compactMap { $0 }

        guard let request = URLRequest(method: .put, url: url, queryItems: queryItems, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func fetchAuthenticationCode(
        completion: @escaping FetchAuthenticationCodeCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("oauth2")
            .appendingPathComponent("oob")
            .appendingPathComponent("code")

        let queryItems = [
            "app_id": clientModel.id,
            "client_name": clientModel.name
        ]

        let headers: [URLRequest.HeaderPair] = [.contentTypeFormURLEncoded]

        guard let request = URLRequest(method: .get, url: url, queryItems: queryItems, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func checkMatched(
        authenticationCode: String,
        completion: @escaping CheckMatchedAuthenticationCodeCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("oauth2")
            .appendingPathComponent("oob")
            .appendingPathComponent("code")
            .appendingPathComponent(authenticationCode)

        let headers: [URLRequest.HeaderPair] = [.contentTypeFormURLEncoded]

        guard let request = URLRequest(method: .get, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }
}
