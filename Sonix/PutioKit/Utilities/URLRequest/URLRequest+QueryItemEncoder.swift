//
//  URLRequest+QueryItemEncoder.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//

import Foundation

extension URLRequest {

    struct URLQueryItemEncoder {

        public init() {}

        public func encode<T: Encodable>(
            _ encodable: T) throws -> [String: CustomStringConvertible]? {

            let parametersData = try JSONEncoder().encode(encodable)

            guard let dictionary = try JSONSerialization.jsonObject(with: parametersData, options: .allowFragments) as? [String: Any?] else {
                return nil
            }

            return dictionary.filter { $0.value != nil && $0.value is CustomStringConvertible } as? [String: CustomStringConvertible]
        }
    }
}
