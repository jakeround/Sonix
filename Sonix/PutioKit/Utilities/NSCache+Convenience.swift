//
//  NSCache+Convenience.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation

extension NSCache {

    @objc convenience init(countLimit: Int) {
        self.init()
        self.countLimit = countLimit
    }

    @objc convenience init(totalCostLimit: Int) {
        self.init()
        self.totalCostLimit = totalCostLimit
    }
}
