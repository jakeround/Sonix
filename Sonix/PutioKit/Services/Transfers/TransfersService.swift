//
//  TransfersService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct TransfersService {

    public typealias TransfersCompletion = (Result<[TransfersService.Model.Transfer], Error>) -> Void
    public typealias TransferCompletion = (Result<TransfersService.Model.Transfer, Error>) -> Void

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

public extension TransfersService {

    func list(
        completion: @escaping TransfersService.TransfersCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("transfers")
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
            completion: Helpers.dictionaryKeyValueCompletion(key: "transfers", completion: completion))
    }

    func details(
        for transferId: Int,
        completion: @escaping TransfersService.TransferCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("\(transferId)")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "transfer", completion: completion))
    }

    func addTransfer(
        parameters: TransfersService.Model.AddParameters,
        completion: @escaping TransfersService.TransferCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("add")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "transfer", completion: completion))
    }

    func retry(
        transfer: TransfersService.Model.Transfer,
        completion: @escaping TransfersService.TransferCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("retry")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            .contentTypeJSON
        ]

        let queryItems = [
            URLQueryItem(name: "id", value: "\(transfer.id)")
        ]

        guard let request = URLRequest(method: .post, url: url, queryItems: queryItems, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(
            with: request,
            completion: Helpers.dictionaryKeyValueCompletion(key: "transfer", completion: completion))
    }

    func cancel(
        transfers: [TransfersService.Model.Transfer],
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {


        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("cancel")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard
            !transfers.isEmpty,
            let body = try? JSONEncoder().encode(["transfer_ids": transfers.map { $0.id } ])
        else {
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

    func clean(
        transfers: [TransfersService.Model.Transfer],
        completion: @escaping DictionaryContentCompletion
    ) -> AnyCancellable? {


        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("clean")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard
            !transfers.isEmpty,
            let body = try? JSONEncoder().encode(["transfer_ids": transfers.map { $0.id } ])
            else {
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

    func cleanAll(
        completion: @escaping DictionaryContentCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("transfers")
            .appendingPathComponent("clean")

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
