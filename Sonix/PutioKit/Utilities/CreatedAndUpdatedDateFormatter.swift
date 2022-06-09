//
//  CreatedAndUpdatedDateFormatter.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 05/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

final class CreatedAndUpdatedDateFormatter: DateFormatter {

    override func date(from string: String) -> Date? {
        DateFormatter.iso8601simple.date(from: string)
            ?? DateFormatter.iso8601simpleWithMilliseconds.date(from: string)
    }
}

extension DateFormatter {

    //    yyyy-MM-dd'T'HH:mm:ss
    static let iso8601simple: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    static let iso8601simpleWithMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }()
}
