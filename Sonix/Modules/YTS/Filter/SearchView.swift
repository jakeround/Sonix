//
//  SearchView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var networkingManager = NetworkManager()
    @StateObject var searchVM = YTSSearchViewModel()
    @Binding var isShowingSearch: Bool

    
 
 

    
    var searchResults: [Movies] {
        if searchVM.searchQuery.isEmpty {
               return networkingManager.movies
           } else {
               return searchVM.searchResults
           }
       }
    
   
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBarView(vm: searchVM, isShowingSearchView: $isShowingSearch)
                   
                
            ScrollView(.vertical, showsIndicators: false) {
        
                    // ForEach with search results
                ForEach(searchResults, id: \.id) { movie in
                        SearchListView(movie: movie)
                            .padding()
                            .onAppear() {
                                if searchVM.searchResults.last?.id == movie.id {
                                    searchVM.loadMoreSearchContent(currentItem: movie)
                                }
                                
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            
           
            
         

        }
        
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//            .preferredColorScheme(.dark)
//    }
//}
