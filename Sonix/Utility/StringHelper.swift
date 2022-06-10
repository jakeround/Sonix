//
//  StringHelper.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import Foundation

public extension Optional where Wrapped == String {
    
    var unwrapped: String {
        guard let self = self else { assertionFailure("The value should not be empty"); return "" }
        return self
    }
    
    var safeUnwrapped: String {
        guard let self = self else { return "" }
        return self
    }
    
}
