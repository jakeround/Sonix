//
//  CompletionTypes.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public typealias SuccessCompletion = (Result<SuccessModel, Error>) -> Void
public typealias StringContentCompletion = (Result<String, Error>) -> Void
public typealias DataContentCompletion = (Result<Data, Error>) -> Void
public typealias DictionaryContentCompletion = (Result<[String: Any], Error>) -> Void
