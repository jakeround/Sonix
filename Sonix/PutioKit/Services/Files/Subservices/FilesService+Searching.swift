//
//  FilesService+Searching.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 06/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public extension FilesService {

    struct Searching {

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

private extension FilesService.Searching {

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

    func searchFiles(
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

public extension FilesService.Searching {

    func searchFiles(
        parameters: FilesService.Model.SearchParameters,
        completion: @escaping FilesService.FetchFilesCompletion) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("search")

        return searchFiles(
            url: url,
            method: .get,
            queryItems: parameters.asURLQueryItems(),
            completion: completion)
    }

    func searchNextPage(
        parameters: FilesService.Model.NextPageParameters,
        completion: @escaping FilesService.FetchFilesCompletion) -> AnyCancellable? {

        guard let body = try? JSONEncoder().encode(parameters) else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("search")
            .appendingPathComponent("continue")

        return searchFiles(
            url: url,
            method: .post,
            body: body,
            completion: completion)
    }
}
