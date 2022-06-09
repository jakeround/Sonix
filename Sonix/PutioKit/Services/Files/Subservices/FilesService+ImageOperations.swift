//
//  FilesService+ImageOperations.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation
import Combine
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension FilesService {

    struct ImageOperations {

        private let clientModel: ApiClientModel
        private let networkHandler: NetworkHandling
        private let credentialsStore: CredentialsStoring
        private let crudService: CRUD

        #if os(macOS)
        public typealias Image = NSImage
        #else
        public typealias Image = UIImage
        #endif

        public init(clientModel: ApiClientModel,
                    networkHandler: NetworkHandling,
                    credentialsStore: CredentialsStoring) {

            self.clientModel = clientModel
            self.networkHandler = networkHandler
            self.credentialsStore = credentialsStore
            self.crudService = CRUD(clientModel: clientModel, networkHandler: networkHandler, credentialsStore: credentialsStore)
        }
    }
}

public extension FilesService.ImageOperations {

    func imageFile(
        for file: FilesService.Model.File,
        completion: @escaping ((Result<Image, Error>) -> Void)
    ) -> AnyCancellable? {

        guard file.type == .image  else {
            completion(.failure(PutIOKitError.invalidParameters))
            return nil
        }

        if let cachedImage = ImageLoader.shared.image(for: file.id) {
            DispatchQueue.main.async { completion (.success(cachedImage)) }
            return nil
        }

        return crudService.downloadURL(for: file.id) { result in
            switch result {
                case .success(let url):
                    _ = ImageLoader.shared.loadImage(from: url).sink(receiveValue: {
                        guard let image = $0 else { return completion(.failure(PutIOKitError.parsingFailed)) }
                        DispatchQueue.main.async { completion(.success(image)) }
                    })
                    break
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
