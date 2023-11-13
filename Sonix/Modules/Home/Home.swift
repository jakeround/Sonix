//
//  Home.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI

struct Home: View {
    @StateObject var networkingManager = NetworkManager(shouldLoadData: true)
    @StateObject var searchManager = SearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    @State private var showingSheet = false
    
    @State private var selectedCategory = ""
    
    var filteredResults: [Movies] {
        selectedCategory.isEmpty ? networkingManager.movies : searchManager.categorizedResults
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HomeFilter(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredResults) { movie in
                        MovieListView(movie: movie)
                            .onAppear {
                                handleLastItemAppearance(movie: movie)
                            }
                    }
                }
                .padding(16)
            }
            .background(Color(AppColor.Figma.Background))
            .navigationBarItems(leading:
                                    HStack {
                Text("Home")
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
            .onChange(of: searchManager.filterBy) { _ in
                searchManager.loadFilteredResults()
            }
            .onChange(of: selectedCategory) {
                searchManager.categorizedResults = []
                searchManager.selectedCategory = $0
                searchManager.searchByCategory()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleLastItemAppearance(movie: Movies) {
        if networkingManager.movies.last?.id == movie.id {
            networkingManager.loadMoreContent(currentItem: movie)
        }
        if searchManager.categorizedResults.last?.id == movie.id {
            searchManager.loadMoreCategorizedContent(currentItem: movie)
        }
    }
    
}

