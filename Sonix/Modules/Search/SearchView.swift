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
    @StateObject var searchVM = SearchViewModel()
    
    @State private var showingSheet = false
    
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

            VStack {
               //
                //    .padding(12)
                   // .padding(12)
            
            
            ScrollView (.vertical, showsIndicators: false) {
                
                SearchBarView(vm: searchVM)
     
                LazyVStack(spacing: 15) {
                    ForEach(searchResults, id: \.id) { movie in
                            SearchListView(movie: movie)
                                //.padding()
                                .onAppear() {
                                    if searchVM.searchResults.last?.id == movie.id {
                                        searchVM.loadMoreSearchContent(currentItem: movie)
                                        printUI("Call")
                                    }
                                    
                                }
                        }
                    
                    
                
                    
                }
                .padding(16)
                .padding(16)
            }
            //.padding()
            .background(Color(AppColor.Figma.Background))
            }
//            .navigationBarItems(leading:
//                                    HStack {
//                Text("Search")
//                    .font(.system(size: 24, weight: .bold, design: .rounded))
//                
//                
//            }, trailing:
//                                    HStack {
//                Button(action: {
//                    showingSheet.toggle()
//                }) {
//                    Image("Settings")
//                        .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
//                }
//                .sheet(isPresented: $showingSheet) {
//                    SettingsScreen()
//                }
//                
//            }
//            )
            
            
            //.frame(maxWidth: .infinity)
            //.navigationBarHidden(true)
            //.navigationViewStyle(StackNavigationViewStyle())
            
            .background(Color(AppColor.Figma.Background))
            
            .navigationBarTitleDisplayMode(.inline)
            //.navigationTitle("Search")
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
