//
//  Coffee.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI
import Foundation

struct Coffee: Identifiable {
    
    let id = UUID()
    let name: String
    let imageURL: String
}

extension Coffee {
    static func all() -> [Coffee] {
        
        return [
            Coffee(name: "Spin", imageURL: "1"),
            Coffee(name: "reg", imageURL: "2")
        ]
    }
}
