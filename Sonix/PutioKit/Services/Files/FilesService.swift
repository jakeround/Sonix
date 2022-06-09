//
//  FilesService.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//

import Foundation
import Combine

public enum FilesService {

    public typealias FetchFilesCompletion = (Result<FilesService.Model.FetchedFiles, Error>) -> Void
    public typealias FetchFileCompletion = (Result<FilesService.Model.File, Error>) -> Void
    public typealias UploadFileOrTransferCompletion = (Result<FileOrServiceProtocol, Error>) -> Void
    public typealias ConversionStatusCompletion = (Result<FilesService.Model.ConversionStatus, Error>) -> Void
    public typealias DownloadURLCompletion = (Result<URL, Error>) -> Void
    public typealias ExtractionsCompletion = (Result<[FilesService.Model.Extraction], Error>) -> Void
    public typealias SubtitlesCompletion = (Result<[FilesService.Model.Subtitle], Error>) -> Void

    static func authenticationHeader(credentialsStore: CredentialsStoring) -> URLRequest.HeaderPair? {
        URLRequest.HeaderPair.bearerAuthorization(credentialsStore: credentialsStore)
    }
}
