//
//  YTS.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI


struct YTS: View {
    @StateObject var networkingManager = NetworkManager()
    
    let columns = [
           GridItem(.adaptive(minimum: 180))
       ]
    
    @State private var showDetails = false

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
                    
                    
                    LazyVGrid(columns: columns, spacing: 30) {
                ForEach(networkingManager.movies) { movie in
                        //LazyVStack(alignment: .leading) {
                    
                    
                 
                    
                    
                    
                    
                    NavigationLink(destination: YTSDetails(movie: movie)) {
                    
                            MovieListView(movie: movie)
                    }.onAppear() {
                        if networkingManager.movies.last?.id == movie.id {
                            networkingManager.loadMoreContent(currentItem: movie)
                        }
                        
                    }
                    
                    
                }
                    }
                    
                    .padding()
                }
                
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Movies")
            // Load API
            .onAppear {
                networkingManager.loadData()
                
            }
          
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private var testview: some View {
        NavigationLink {
            Text("Detals View")
        } label: {
            Text("Hello World")
        }
    }
    
    
    
    
}

struct YTS_Previews: PreviewProvider {
    static var previews: some View {
        YTS( )
    }
}
