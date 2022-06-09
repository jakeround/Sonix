//
//  FileOrTransferProtocol.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 07/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol FileOrServiceProtocol {}

extension FilesService.Model.File: FileOrServiceProtocol {}
