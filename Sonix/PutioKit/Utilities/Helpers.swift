//
//  Helpers.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

enum Helpers {

    static func transformationBlock<Receive, Send>(
        transformation: @escaping (Receive) -> Send,
        _ completion: @escaping (Result<Send, Error>) -> Void
    ) -> ((Result<Receive, Error>) -> Void) {

        return { result in
            switch result {
                case .success(let valueReceived):
                    completion(.success(transformation(valueReceived)))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    static func dictionaryKeyValueCompletion<T: Decodable>(
        key: String,
        completion: @escaping ((Result<T, Error>) -> Void)) -> (Result<[String: Any], Error>) -> Void {

        return { result in

            switch result {
                case .success(let dictionary):
                    let decoder = JSONDecoder.putioKitDecoder
                    guard let value = dictionary[key],
                        let data = try? JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)
                    else {
                        completion(.failure(PutIOKitError.invalidResponse("Value for key \(key) was not JSON value")))
                        return
                    }
                    guard let decoded = try? decoder.decode(T.self, from: data)
                    else {
                        if let error = try? decoder.decode(ErrorModel.self, from: data) {
                            completion(.failure(error))
                        } else {
                            completion(.failure(PutIOKitError.invalidResponse("Value for key \(key) was nott of type \(T.self)")))
                        }
                        return
                    }
                    completion(.success(decoded))
                case .failure(let error):
                    return completion(.failure(error))
            }

        }
    }
}
