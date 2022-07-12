//
//  YTS.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI


struct YTS: View {
    @StateObject var networkingManager = NetworkManager()
    @StateObject var searchManager = YTSSearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    @State private var showDetails = false
    
    @State var showSheetView = false
    @State var showSearchView = false
    
    @State private var selectedCategory = ""
    
    var filteredResults: [Movies] {
        if selectedCategory == "" {
            return networkingManager.movies
        } else {
            return searchManager.categorizedResults
        }
    }

    
    var body: some View {
        NavigationView {
            
            
            
            
            
            ScrollView {
                CategoryView(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
                    .padding()
                
                
                
                //Button("Change Genre") {
                //    showDetails.toggle()
                // }
                //if showDetails {
                //    Text("Sort by Year")
                //        .font(.largeTitle)
                //}
                
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(filteredResults, id: \.id) { movie in
                        
                        MovieListView(movie: movie)
                        
                            .onAppear() {
                                if networkingManager.movies.last?.id == movie.id {
                                    networkingManager.loadMoreContent(currentItem: movie)
                                }
                                if searchManager.categorizedResults.last?.id == movie.id {
                                    searchManager.loadMoreCategorizedContent(currentItem: movie)
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
            }, trailing:
                                    
                                    Button(action: {
                showSearchView.toggle()
            }, label: {
                Image(systemName: "magnifyingglass")
            })
                                
                                
            )
            .onChange(of: searchManager.filterBy, perform: { _ in
                searchManager.loadFilteredResults()
                print(networkingManager.sortby)
            })
            
            .onChange(of: selectedCategory, perform: { _ in
                searchManager.categorizedResults = []
                searchManager.selectedCategory = selectedCategory
                searchManager.searchByCategory()
      
            })
            
            
            
            //
            ////             Redundant
            //            .onAppear {
            //                networkingManager.loadData()
            //
            //            }
            .sheet(isPresented: $showSheetView) {
                SettingsScreen()
            }
            .sheet(isPresented: $showSearchView) {
                SearchView(searchVM: searchManager, isShowingSearch: $showSearchView)
            }
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: networkingManager.sortby) { newValue in
            networkingManager.movies = []
            networkingManager.loadData()
        }
        
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
