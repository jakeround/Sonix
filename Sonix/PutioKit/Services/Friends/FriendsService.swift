//
//  FriendsService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct FriendsService {

    public typealias ListCompletion = (Result<[FriendsService.Model.Friend], Error>) -> Void

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

private extension FriendsService {

    func performRequestOperation(
        with url: URL,
        completion: @escaping SuccessCompletion) -> AnyCancellable? {

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        guard let request = URLRequest(method: .post, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(with: request, completion: completion)
    }
}

extension FriendsService {

    func list(
        completion: @escaping ListCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent("list")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "friends", completion: completion))
    }

    func waitingRequestsList(
        completion: @escaping ListCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent("waiting-requests")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "friends", completion: completion))
    }

    func request(
        username: String,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent(username)
            .appendingPathComponent("request")

        return performRequestOperation(with: url, completion: completion)
    }

    func approveRequest(
        from username: String,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent(username)
            .appendingPathComponent("aprrove")

        return performRequestOperation(with: url, completion: completion)
    }

    func denyRequest(
        from username: String,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent(username)
            .appendingPathComponent("deny")

        return performRequestOperation(with: url, completion: completion)
    }

    func unfriend(
        username: String,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("friends")
            .appendingPathComponent(username)
            .appendingPathComponent("unfriend")

        return performRequestOperation(with: url, completion: completion)
    }
}
