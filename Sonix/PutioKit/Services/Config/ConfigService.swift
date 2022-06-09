//
//  ConfigService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct ConfigService {

    private let clientModel: ApiClientModel
    private let networkHandler: NetworkHandling
    private let credentialsStore: CredentialsStoring

    public init(clientModel: ApiClientModel,
                networkHandler: NetworkHandling,
                credentialsStore: CredentialsStoring) {

        self.clientModel = clientModel
        self.networkHandler = networkHandler
        self.credentialsStore = credentialsStore
    }
}

extension ConfigService {

    func fetch(
        completion: @escaping DictionaryContentCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("config")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .get, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func write(
        config: [String: Any],
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("config")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard let body = try? JSONSerialization.data(withJSONObject: ["config": config], options: .fragmentsAllowed) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .put, url: url, body: body, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func fetch(
        key: String,
        completion: @escaping DictionaryContentCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("config")
            .appendingPathComponent(key)

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .get, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func write(
        key: String,
        value: Any,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("config")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard let body = try? JSONSerialization.data(withJSONObject: ["value": value], options: .fragmentsAllowed) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .put, url: url, body: body, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func delete(
        key: String,
        completion: @escaping DictionaryContentCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("config")
            .appendingPathComponent(key)

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .delete, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }
}
