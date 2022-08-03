//
//  SearchView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var networkingManager = NetworkManager(shouldLoadData: true)
    @StateObject var searchVM = YTSSearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    //@Binding var isShowingSearch: Bool
    
    var searchResults: [Movies] {
        if searchVM.searchQuery.isEmpty {
            return networkingManager.movies
        } else {
            if searchVM.searchResults.isEmpty {
                let text = searchVM.searchQuery.trimmed.lowercased()
                let filtered = networkingManager.movies.filter({ ($0.titleLong?.lowercased().contains(text) ?? false) || ($0.descriptionFull?.lowercased().contains(text) ?? false) })
                return filtered
            } else {
                return searchVM.searchResults
            }
        }
    }
    
    var body: some View {
        NavigationView {

            ScrollView (.vertical, showsIndicators: false) {
                VStack (spacing: 0) {
                    SearchBarView(vm: searchVM)
     
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(searchResults, id: \.id) { movie in
                            SearchListView(movie: movie)
                                //.padding()
                                .onAppear() {
                                    if searchVM.searchResults.last?.id == movie.id {
                                        searchVM.loadMoreSearchContent(currentItem: movie)
                                    }
                                    
                                }
                        }
                    
                    
                }
                    
                }
                .padding(.left, 16)
                .padding(.right, 16)
            }
            .padding(0)
            .background(Color(AppColor.BackGround.darkBackground))
            
            
            
            //.frame(maxWidth: .infinity)
            //.navigationBarHidden(true)
            //.navigationViewStyle(StackNavigationViewStyle())
            
            .background(Color(AppColor.BackGround.darkBackground))
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Search")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
    


//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//            .preferredColorScheme(.dark)
//    }
//}
