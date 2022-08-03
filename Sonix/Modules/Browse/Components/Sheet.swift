//
//  Sheet.swift
//  Sonix
//
//  Created by Jake Round on 06/07/2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var oneActive: Bool
    @Binding var twoActive: Bool
    
    var body: some View {
        Menu {
            Button {
                oneActive = true
            } label: {
                Text("Option One")
            }
        
            Button {
                twoActive = true
            } label: {
                Text("Option Two")
            }
    
        } label: {
            Image(systemName: "ellipsis")
        }
    }
}

struct Sheet: View {
    @State private var oneActive: Bool = false
    @State private var twoActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Option One View"), isActive: $oneActive) { EmptyView() }
                NavigationLink(destination: Text("Option Two View"), isActive: $twoActive) { EmptyView() }
                ScrollView {
                    ForEach(0..<100, id: \.self) { index in
                        Text("\(index)")
                    }
                }
            }
            .navigationTitle("TItle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    MenuView(oneActive: $oneActive, twoActive: $twoActive)
                }
            }
        }
    }
}
