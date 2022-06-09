//
//  SharesService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct SharesService {

    public typealias ListCompletion = (Result<[SharesService.Model.Share], Error>) -> Void
    public typealias SharedWithCompletion = (Result<[SharesService.Model.User], Error>) -> Void

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

public extension SharesService {

    func share(
        files: [Int],
        friends: [String],
        shareWithEveryone: Bool = false,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("share")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard
            !files.isEmpty, !friends.isEmpty || shareWithEveryone
        else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let parameters = SharesService.Model._ShareParameters(
            files: files,
            friends: shareWithEveryone ? ["everyone"] : friends)

        guard let body = try? JSONEncoder().encode(parameters) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .post, url: url, body: body, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func sharePublically(
        fileId: Int,
        username: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) -> AnyCancellable?  {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("\(fileId)")
            .appendingPathComponent("share_public")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
        ]

        guard let request = URLRequest(method: .post, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: Helpers.dictionaryKeyValueCompletion(key: "token", completion: { (result: Result<String, Error>) in
            switch result {
                case .success(let token):
                    let url = Constants.shareURL.appendingPathComponent(username).appendingPathComponent(token)
                    completion(.success(url))
                case .failure(let error):
                    completion(.failure(error))
            }
        }))
    }

    func list(
        completion: @escaping ListCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("shared")

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

        return networkHandler.startDataTask(
            with: request,
            completion: Helpers.dictionaryKeyValueCompletion(key: "shared", completion: completion))
    }

    func sharedWith(
        fileId: Int,
        completion: @escaping SharedWithCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("\(fileId)")
            .appendingPathComponent("shared-with")

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

        return networkHandler.startDataTask(
            with: request,
            completion: Helpers.dictionaryKeyValueCompletion(key: "shared-with", completion: completion))
    }

    func unfriend(
        friends: [String] = [],
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let _friends = friends.isEmpty ? ["everyone"] : friends

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("unshare")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard let body = try? JSONEncoder().encode(_friends) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .post, url: url, body: body, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }
}
