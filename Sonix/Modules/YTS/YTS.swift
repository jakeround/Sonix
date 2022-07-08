//
//  YTS.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI


struct YTS: View {
    @StateObject var networkingManager = NetworkManager()
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    @State private var showDetails = false
    
    @State var showSheetView = false

    var body: some View {
        NavigationView {
            
           
            
            
            
                ScrollView {
                    
                   
                            //Button("Change Genre") {
                            //    showDetails.toggle()
                           // }
                            //if showDetails {
                            //    Text("Sort by Year")
                            //        .font(.largeTitle)
                            //}
                    
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(networkingManager.movies) { movie in
                        
                            MovieListView(movie: movie)
                            
                            .onAppear() {
                        if networkingManager.movies.last?.id == movie.id {
                            networkingManager.loadMoreContent(currentItem: movie)
                        }
                        
                    }
                    
                    
                    }// Close LazyVGrid
                        
                        
                    }
                    
                    .padding()
                }
            
                
            
                .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Browse")
            .navigationBarItems(leading:
                    Button(action: {
                        self.showSheetView.toggle()
                    }) {
                        Image(systemName: "gearshape")
                    }
                )
            
            // Redundant
            //.onAppear {
            //    networkingManager.loadData()
            //
            //}
            .sheet(isPresented: $showSheetView) {
                        SettingsScreen()
                    }
          
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    
    
    
    
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct YTS_Previews: PreviewProvider {
    static var previews: some View {
        YTS( )
    }
}
