//
//  CoffeeView.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var model = Coffee.all()
    
    var body: some View {
        
        NavigationView {
        List {
            
            ForEach(model) { coffee in
                CoffeeCell(coffee: coffee)
        
        }
        }
        
    }
}

struct CoffeeCell : View {
    
    
    let coffee: Coffee
    var body: some View {
        NavigationLink (destination: CoffeeDetail(coffee:coffee)) {
        Image(coffee.imageURL)
    Text(coffee.name)
        }
}
        
    }
}
