//
//  CoffeeDetail.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI

struct CoffeeDetail: View {
    
    let coffee: Coffee
    
    var body: some View {
        Text(coffee.name)
        Image(coffee.imageURL)
        
        
    }
}


