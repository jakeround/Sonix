//
//  JSONDecoder+PutioKit.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension JSONDecoder {

    static var putioKitDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(CreatedAndUpdatedDateFormatter())
        return decoder
    }
}
