//
//  Data+MultipartForm.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 07/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

private let kNewDataLine = "\r\n"

extension Data {

    enum CustomOperation: Error { case appendString }

    mutating func append(_ string: String) throws {

        guard let data = string.data(using: .utf8, allowLossyConversion: true) else {
            throw CustomOperation.appendString
        }
        append(data)
    }

    func multipartForm(
        fields: [String: String],
        mimeType: String?,
        boundary: String) throws -> Data {

        var data = try fields.reduce(Data()) {
            var _data = $0
            try _data.append("--\(boundary)\(kNewDataLine)")
            if ($1.key == "file") {
                try _data.append("Content-Disposition: form-data; name=\"\($1.key)\"; filename=\"\($1.value)\"\(kNewDataLine)")
                if let mimeType = mimeType {
                    try _data.append("Content-Type: \(mimeType)\(kNewDataLine)\(kNewDataLine)\(kNewDataLine)")
                }
                try _data.append(kNewDataLine)
            } else {
                try _data.append("Content-Disposition: form-data; name=\"\($1.key)\"\(kNewDataLine)\(kNewDataLine)\($1.value)\(kNewDataLine)")
            }
            return _data
        }

        data.append(self)
        try data.append(kNewDataLine)
        try data.append("--\(boundary)--")

        return data
    }
}
