//
//  OperationQueue+Convenience.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation

extension OperationQueue {

    convenience init(maxConcurrentOperationCount: Int) {
        self.init()
        self.maxConcurrentOperationCount = 5
    }
}
