//
//  Home.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI

//import BottomSheet


struct Home: View {
    @StateObject var networkingManager = NetworkManager(shouldLoadData: true)
    @StateObject var searchManager = SearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 193))]
    
    @State var showList = false
    @State var showMapSetting = false
    
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
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            HStack {

            GeometryReader { geo in
            ScrollView (.vertical, showsIndicators: false) {
                VStack (spacing: 0) {
                HomeFilter(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
                    
                    
     
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredResults, id: \.id) { movie in
                        
                        MovieListView(movie: movie)
                        
                            .onAppear() {
                                if networkingManager.movies.last?.id == movie.id {
                                    networkingManager.loadMoreContent(currentItem: movie)
                                }
                                if searchManager.categorizedResults.last?.id == movie.id {
                                    searchManager.loadMoreCategorizedContent(currentItem: movie)
                                }
                                   
                                        networkingManager.loadData()
                    
                                    
                                
                            }
                        
                        
                            
                        
                    }// Close LazyVGrid
                   
                    
                }
                }
                .padding(.left, 16)
                .padding(.right, 16)
            }
            .padding(0)
            .background(Color(AppColor.Figma.Background))
            
         
            // Content isn't refreshed when just using filter option (have to select category then filter)
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
                        .onAppear {
                            networkingManager.loadData()
        
                        }
            .sheet(isPresented: $showSheetView) {
                SettingsScreen()
            }

                
        
                
       
            //.sheet(isPresented: $showSearchView) {
           //     SearchView(searchVM: searchManager, isShowingSearch: $showSearchView)
           // }
            }.background(Color(AppColor.Figma.Background))
                    .navigationBarItems(leading:
                                            HStack {
                        Text("Sonix")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        
                    }, trailing:
                                            HStack {
                        Button(action: {
                            showingSheet.toggle()
                        }) {
                            Image("Settings")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                        }
                        .sheet(isPresented: $showingSheet) {
                            SettingsScreen()
                        }
                        
                    }
                    )
        }
        }
        
        .onChange(of: networkingManager.sortby) { newValue in
            networkingManager.movies = []
            networkingManager.loadData()
        }
        
        .onAppear {
            print("ContentView appeared!")
        }
        
    }
}
    


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home( )
    }
}

