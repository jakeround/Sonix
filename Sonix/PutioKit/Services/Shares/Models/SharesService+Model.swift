//
//  SharesService+Model.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension SharesService { enum Model {} }

extension SharesService.Model {

    struct _ShareParameters: Codable, Hashable {
        let files: [Int]
        let friends: [String]

        private enum CodingKeys: String, CodingKey {
            case files = "file_ids"
            case friends
        }
    }
}

public extension SharesService.Model {

    struct Share: Codable, Hashable {
        let id: Int
        let name: String
        let size: Int
        private enum CodingKeys: String, CodingKey { case id, name, size }
    }
}

public extension SharesService.Model {

    struct User: Codable, Hashable {
        let shareId: Int
        let name: String
        let avatarURL: URL?
        private enum CodingKeys: String, CodingKey {
            case shareId = "share_id"
            case name = "user_name"
            case avatarURL = "user_avatar_url"
        }
    }
}
