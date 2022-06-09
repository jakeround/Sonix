//
//  FriendsService+Model.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension FriendsService { enum Model {} }

public extension FriendsService.Model {

    struct Friend: Codable, Hashable {
        let id: Int
        let name: String
        let avatarURL: URL?

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case avatarURL = "avatar_url"
        }
    }
}
