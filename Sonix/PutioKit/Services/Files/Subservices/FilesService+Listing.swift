//
//  FilesService+Listing.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 06/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public extension FilesService {

    struct Listing {

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
}

private extension FilesService.Listing {

    func rewriteCompletion(
        _ result: Result<FilesService.Model.FetchedFiles, Error>,
        completion: @escaping FilesService.FetchFilesCompletion) {

        switch result {
            case .success(let fetchedFiles):
                let files: [FilesService.Model.File] = fetchedFiles.files.map { original in
                    guard original.type == .video else { return original }
                    let url = Constants.baseURL
                        .appendingPathComponent("files")
                        .appendingPathComponent("\(original.id)")
                        .appendingPathComponent("hls")
                        .appendingPathComponent("media.m3u8")

                    let request = URLRequest(method: .get, url: url, queryItems: [
                        URLQueryItem(name: "subtitle_key", value: "all"),
                        URLQueryItem(name: "oauth_token", value: self.credentialsStore.accessToken ?? "")
                        ])

                    return original.mutate(playlistURL: request?.url)
                }

                completion(.success(FilesService.Model.FetchedFiles(
                    files: files,
                    parent: fetchedFiles.parent,
                    total: fetchedFiles.total,
                    cursor: fetchedFiles.cursor,
                    status: fetchedFiles.status)))
            case .failure: completion(result)

        }
    }

    func fetchFiles(
        url: URL,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil,
        contentType: URLRequest.HeaderPair = .contentTypeJSON,
        completion: @escaping FilesService.FetchFilesCompletion) -> AnyCancellable? {

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            contentType
        ]

        guard let request = URLRequest(method: method, url: url, queryItems: queryItems, body: body, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        return networkHandler.startDataTask(
            with: request,
            completion: { self.rewriteCompletion($0, completion: completion) })
    }
}

public extension FilesService.Listing {

    func fetchFiles(
        parameters: FilesService.Model.ListParameters,
        completion: @escaping FilesService.FetchFilesCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("list")

        return fetchFiles(
            url: url,
            method: .get,
            queryItems: parameters.asURLQueryItems(),
            completion: completion)
    }

    func fetchNextPage(
        parameters: FilesService.Model.NextPageParameters,
        completion: @escaping FilesService.FetchFilesCompletion
    ) -> AnyCancellable? {

        guard let body = try? JSONEncoder().encode(parameters) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("list")
            .appendingPathComponent("continue")

        return fetchFiles(
            url: url,
            method: .post,
            body: body,
            completion: completion)
    }

    func activeExtractions(
        completion: @escaping FilesService.ExtractionsCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("extract")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "extractions", completion: completion))
    }
}
