//
//  URLQueryItemConvertible.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

protocol URLQueryItemConvertible {

    func asURLQueryItems() -> [URLQueryItem]

    func transformIfNotNil(
        _ value: CustomStringConvertible?,
        name: String) -> URLQueryItem?
}

extension URLQueryItemConvertible {

    func transformIfNotNil(
        _ value: CustomStringConvertible?,
        name: String) -> URLQueryItem? {
        guard let _value = value else { return nil }
        return URLQueryItem(name: name, value: _value.description)
    }
}
