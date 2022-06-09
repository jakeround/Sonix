//
//  ZipService+Models.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension ZipService { enum Model {} }

public extension ZipService.Model {

    struct Zip: Codable, Hashable {
        let id: Int
        let createdAt: Date

        private enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
        }
    }
}

public extension ZipService.Model {

    struct MissingFile: Codable, Hashable {
        let id: Int
        let name: String
        let isMissing: Bool

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case isMissing = "missing"
        }
    }
}

public extension ZipService.Model {

    struct ZipDetails: Codable, Hashable {
        enum Status: String, Codable, Hashable {
            case new = "NEW"
            case processing = "PROCESSING"
            case done = "DONE"
            case error = "ERROR"
        }

        let status: Status
        let url: URL?
        let size: Int
        let missingFiles: [MissingFile]?

        private enum CodingKeys: String, CodingKey {
            case status = "zip_status"
            case url
            case size
            case missingFiles = "missing_files"
        }
    }
}
