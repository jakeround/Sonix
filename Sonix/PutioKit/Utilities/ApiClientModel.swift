//
//  ApiClientModel.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation

public struct ApiClientModel: Codable, Equatable, Hashable {

    let id: String
    let secret: String
    let name: String

    public init(
        id: String,
        secret: String,
        name: String) {

        self.id = id
        self.secret = secret
        self.name = name
    }
}
