//
//  RSSService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct RSSService {

    public typealias ListCompletion = (Result<[RSSService.Model.Feed], Error>) -> Void
    public typealias FeedCompletion = (Result<RSSService.Model.Feed, Error>) -> Void

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

private extension RSSService {

    func performFeedOperation(
        url: URL,
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

extension RSSService {

    func list(
        completion: @escaping ListCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
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
            completion: Helpers.dictionaryKeyValueCompletion(key: "feeds", completion: completion))
    }

    func feed(
        with feedId: Int,
        completion: @escaping FeedCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("\(feedId)")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "feed", completion: completion))
    }

    func updateFeed(
        with feedId: Int,
        parameters: RSSService.Model.FeedParameters,
        completion: @escaping FeedCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("\(feedId)")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

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

        return networkHandler.startDataTask(
            with: request,
            completion: Helpers.dictionaryKeyValueCompletion(key: "feed", completion: completion))
    }

    func createFeed(
        parameters: RSSService.Model.FeedParameters,
        completion: @escaping FeedCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("create")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

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

        return networkHandler.startDataTask(
            with: request,
            completion: Helpers.dictionaryKeyValueCompletion(key: "feed", completion: completion))
    }

    func pauseFeed(
        with feedId: Int,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("\(feedId)")
            .appendingPathComponent("pause")

        return performFeedOperation(url: url, completion: completion)
    }

    func resumeFeed(
        with feedId: Int,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("\(feedId)")
            .appendingPathComponent("resume")

        return performFeedOperation(url: url, completion: completion)
    }

    func deleteFeed(
        with feedId: Int,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("rss")
            .appendingPathComponent("\(feedId)")
            .appendingPathComponent("delete")

        return performFeedOperation(url: url, completion: completion)
    }
}
