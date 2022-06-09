//
//  ZipService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public struct ZipService {

    public typealias CreateCompletion = (Result<Int, Error>) -> Void
    public typealias ListCompletion = (Result<[ZipService.Model.Zip], Error>) -> Void
    public typealias DetailsCompletion = (Result<ZipService.Model.ZipDetails, Error>) -> Void

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

extension ZipService {

    func create(
        fileIds: [Int],
        completion: @escaping CreateCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("zips")
            .appendingPathComponent("create")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard
            !fileIds.isEmpty,
            let body = try? JSONEncoder().encode(["file_ids": fileIds])
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

        let _completion: DictionaryContentCompletion = { result in
            switch result {
                case .success(let dictionary):
                    guard
                        let zipId = dictionary["zip_id"] as? Int
                    else {
                        completion(.failure(PutIOKitError.invalidResponse("zip_id was invalid or missing")))
                        return
                    }
                    completion(.success(zipId))
                case .failure(let error): completion(.failure(error))
            }
        }

        return networkHandler.startDataTask(with: request, completion: _completion)
    }

    func list(
        completion: @escaping ListCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("zips")
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
            completion: Helpers.dictionaryKeyValueCompletion(key: "zips", completion: completion))
    }

    func details(
        zipId: Int,
        completion: @escaping DetailsCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("zips")
            .appendingPathComponent("\(zipId)")

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
}
