//
//  FilesService+CRUD.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 06/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import Combine

public extension FilesService {

    struct CRUD {

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

public extension FilesService.CRUD {

    func createFolder(
        parameters: FilesService.Model.CreateFolderParameters,
        completion: @escaping FilesService.FetchFileCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("create-folder")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "file", completion: completion))
    }

    func renameFile(
        parameters: FilesService.Model.RenameFileParameters,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("rename")

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

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func moveFiles(
        parameters: FilesService.Model.MoveFilesParameters,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        guard !parameters.fileIds.isEmpty else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("move")

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

        return networkHandler.startDataTask(with: request, completion: completion)
    }

    func convertVideoFileToMP4(
        with fileId: Int,
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("\(fileId)")
            .appendingPathComponent("mp4")

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

    func deleteFiles(
        fileIds: [Int],
        completion: @escaping SuccessCompletion
    ) -> AnyCancellable? {

        guard !fileIds.isEmpty else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("delete")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        guard let body = try? JSONEncoder().encode(["file_ids": fileIds]) else {
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

    func uploadFile(
        parameters: FilesService.Model.UploadFileParameters,
        completion: @escaping FilesService.UploadFileOrTransferCompletion
    ) -> AnyCancellable? {

        guard !parameters.file.isEmpty || !parameters.filename.isEmpty else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        let url = Constants.uploadBaseURL
            .appendingPathComponent("files")
            .appendingPathComponent("upload")

        guard let authenticationHeader = FilesService.authenticationHeader(credentialsStore: credentialsStore) else {
            completion(.failure(PutIOKitError.unauthorised))
            return nil
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: [URLRequest.HeaderPair] = [
            authenticationHeader,
            URLRequest.HeaderPair.contentTypeMultipart(boundary: boundary)
        ]

        guard let request = URLRequest(method: .post, url: url, headers: headers) else {
            completion(.failure(PutIOKitError.invalidURL))
            return nil
        }

        let formFields: [String: String] = [
            "filename": parameters.filename,
            "parent_id": "\(parameters.parentId)",
            "file": "\(parameters.filename)" + (parameters.file.ext != nil ? ".\(parameters.file.ext!)" : "")
        ]


        guard
            let data = try? parameters.file.multipartForm(fields: formFields, mimeType: parameters.file.mimeType, boundary: boundary)
        else {
            completion(.failure(PutIOKitError.Files.invalidMultipartData))
            return nil
        }

        return networkHandler.startUploadTask(with: request, data: data)
            .tryMap { [networkHandler] in
                if let file: FilesService.Model._FetchedFile = try? networkHandler.decode($0.data) {
                    return file.file
                } else if let error: ErrorModel = try? networkHandler.decode($0.data) {
                    throw error
                } else {
                    throw PutIOKitError.parsingFailed
                }
        }.sink(receiveCompletion: { _completion in
            switch _completion {
                case .finished: break
                case .failure(let error): completion(.failure(error))
            }
        }, receiveValue: { item in completion(.success(item)) })
    }

    func conversionStatus(
        for fileId: Int,
        completion: @escaping FilesService.ConversionStatusCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("\(fileId)")
            .appendingPathComponent("mp4")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "mp4", completion: completion))
    }

    func downloadURL(
        for fileId: Int,
        completion: @escaping FilesService.DownloadURLCompletion
    ) -> AnyCancellable? {
        let url = Constants.baseURL
            .appendingPathComponent("files")
            .appendingPathComponent("\(fileId)")
            .appendingPathComponent("url")

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
            completion: Helpers.dictionaryKeyValueCompletion(key: "url", completion: completion))
    }
}
