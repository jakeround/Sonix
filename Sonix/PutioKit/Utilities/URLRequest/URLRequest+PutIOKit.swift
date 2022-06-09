//
//  URLRequest+PutIOKit.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation

extension URLRequest {

    private static func makeURLComponents(
        url: URL,
        resolvingAgainstBaseURL: Bool,
        queryItems: [String: CustomStringConvertible]) -> URLComponents? {
        return makeURLComponents(
            url: url,
            resolvingAgainstBaseURL: resolvingAgainstBaseURL,
            queryItems: queryItems.map { URLQueryItem(name: $0.key, value: $0.value.description) })
    }

    private static func makeURLComponents(
        url: URL,
        resolvingAgainstBaseURL: Bool,
        queryItems: [URLQueryItem]) -> URLComponents? {

        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL)
            else {
                return nil
        }

        components.queryItems = queryItems

        return components
    }

    init?(
        method: HTTPMethod,
        url: URL,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 30,
        resolvingAgainstBaseURL: Bool = false,
        queryItems: [String: CustomStringConvertible],
        body: Data? = nil,
        headers: [HeaderPair] = []) {

        self.init(
            method: method,
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval,
            resolvingAgainstBaseURL: resolvingAgainstBaseURL,
            queryItems: URLRequest.makeURLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL, queryItems: queryItems)?.queryItems ?? [],
            body: body,
            headers: headers)
    }

    init?(
        method: HTTPMethod,
        url: URL,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 30,
        resolvingAgainstBaseURL: Bool = false,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil,
        headers: [HeaderPair] = []) {

        var request: URLRequest

        if !queryItems.isEmpty,
            let components = URLRequest.makeURLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL, queryItems: queryItems),
            let _url = components.url {
            request = URLRequest(url: _url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        } else {
            request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        }
        request.httpBody = body
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.name) }

        self = request
    }
}
