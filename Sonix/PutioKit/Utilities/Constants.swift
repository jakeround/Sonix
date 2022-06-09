//
//  Constants.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 04/03/2020.
//

import Foundation

enum Constants {
    static let baseURL = URL(string: "https://api.put.io")!.appendingPathComponent("v2")
    static let uploadBaseURL = URL(string: "https://upload.put.io")!.appendingPathComponent("v2")
    static let shareURL = URL(string: "https://app.put.io/a-gift-from")!
}
