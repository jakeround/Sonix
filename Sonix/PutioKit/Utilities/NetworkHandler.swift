//
//  NetworkHandler.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation
import Combine

public protocol NetworkHandling {

    func startDataTask<T>(
        with request: URLRequest) -> AnyPublisher<T, Error>

    func startDataTask<T>(
        with request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable

    func startUploadTask(
        with request: URLRequest,
        data: Data) -> AnyPublisher<(data: Data, response: URLResponse), Error>

    func startUploadTask<T>(
        with request: URLRequest,
        data: Data,
        completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable

    var jsonDecoder: JSONDecoder { get }

    func decode<T: Decodable>(_ data: Data) throws -> T
}

private extension URLSession {

    func validate(_ input: (data: Data, response: URLResponse)) throws -> (data: Data, response: URLResponse) {

        if let httpResponse = input.response as? HTTPURLResponse,
            httpResponse.statusCode < 200 || httpResponse.statusCode > 399 {

            let error: ErrorModel = {

                guard let error = try? ErrorModel.init(jsonData: input.data) else {
                    return ErrorModel(message: "Network request failed", status: "ERROR", code: httpResponse.statusCode)
                }
                return error
            }()

            let data = try JSONEncoder().encode(error)

            return (data, httpResponse)
        }
        return input
    }
}

extension URLSession: NetworkHandling {

    public var jsonDecoder: JSONDecoder {
        JSONDecoder.putioKitDecoder
    }

    public func decode<T>(_ data: Data) throws -> T {

        if T.self == Data.self { return data as! T }
        else if T.self == String.self, let content = String(data: data, encoding: .utf8) as? T { return content }
        else if let error = try? jsonDecoder.decode(ErrorModel.self, from: data) { throw error } // NOTE: That must be before the dictionary check
        else if T.self == [String: Any].self, let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? T { return dictionary }

        guard let type = T.self as? Decodable.Type else { throw PutIOKitError.parsingFailed }

        let genericType = try type.init(jsonData: data, jsonDecoder: jsonDecoder)

        guard let decoded = genericType as? T else { throw PutIOKitError.parsingFailed }

        return decoded
    }

    public func decodeResult<T>(_ data: Data) throws -> Result<T, Error> {

        do {
            let result: T = try decode(data)
            return .success(result)
        } catch(let exception) {
            return .failure(exception)
        }
    }

    public func startDataTask<T>(
        with request: URLRequest) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.global())
            .tryMap { try self.validate($0) }
            .tryMap { try self.decode($0.data) }
            .eraseToAnyPublisher()
    }

    public func startDataTask<T>(
        with request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable {
        dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.global())
            .tryMap { try self.validate($0) }
            .tryMap { try self.decode($0.data) }
            .sink(receiveCompletion: { _completion in
                switch _completion {
                    case .finished: break
                    case .failure(let error):
                        let rewrittenError = PutIOKitError.isOffline(error: error) ? PutIOKitError.offline : error
                        completion(.failure(rewrittenError)
                    )
                }
            }, receiveValue: { item in completion(.success(item)) })
    }

    public func startUploadTask(
        with request: URLRequest,
        data: Data) -> AnyPublisher<(data: Data, response: URLResponse), Error> {

        let downstream = PassthroughSubject<(data: Data, response: URLResponse), Error>()

        DispatchQueue.global().async {
            self.uploadTask(with: request, from: data) { (data, response, error) in
                switch (data, response, error) {
                    case let (data, response?, nil):
                        downstream.send((data ?? Data(), response))
                        downstream.send(completion: .finished)
                    case let (_, _, error as URLError):
                        downstream.send(completion: .failure(error))
                    default:
                        downstream.send(completion: .failure(URLError(.unknown)))
                }
            }.resume()
        }

        return downstream
            .tryMap { try self.validate($0) }
            .eraseToAnyPublisher()
    }

    public func startUploadTask<T>(
        with request: URLRequest,
        data: Data,
        completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable {

        startUploadTask(with: request, data: data)
            .receive(on: DispatchQueue.global())
            .tryMap { try self.decode($0.data) }
            .sink(receiveCompletion: { _completion in
                switch _completion {
                    case .finished: break
                    case .failure(let error):
                        let rewrittenError = PutIOKitError.isOffline(error: error) ? PutIOKitError.offline : error
                        completion(.failure(rewrittenError))
                }
            }, receiveValue: { item in completion(.success(item)) })
    }
}
