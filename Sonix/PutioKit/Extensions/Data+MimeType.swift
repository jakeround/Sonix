//
//  Data+MimeType.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 07/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension Data {

    var mimeType: String? { Swime.mimeType(data: self)?.mime }

    var ext: String? { Swime.mimeType(data: self)?.ext }
}
