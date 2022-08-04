//
//  YTS.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI
import BottomSheet


struct BrowseYTS: View {
    @StateObject var networkingManager = NetworkManager(shouldLoadData: true)
    @StateObject var searchManager = SearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
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
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
            ScrollView (.vertical, showsIndicators: false) {
                VStack (spacing: 0) {
                CategoryView(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
     
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
                }
                .padding(.left, 16)
                .padding(.right, 16)
            }
            .padding(0)
            .background(Color(AppColor.BackGround.darkBackground))
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Browse")
            .navigationBarHidden(true)
                                
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
            .bottomSheet(
                isPresented: $showMapSetting,
                height: geo.size.height,
                topBarHeight: 16,
                topBarCornerRadius: 16,
                showTopIndicator: true
            ) {
           
                Test()
            }
                printUI(geo.size.height)
            //.sheet(isPresented: $showSearchView) {
           //     SearchView(searchVM: searchManager, isShowingSearch: $showSearchView)
           // }
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
        BrowseYTS( )
    }
}

enum NoFlipEdge {
    case left, right
}

struct NoFlipPadding: ViewModifier {
    let edge: NoFlipEdge
    let length: CGFloat?
    @Environment(\.layoutDirection) var layoutDirection
    
    private var computedEdge: Edge.Set {
        if layoutDirection == .rightToLeft {
            return edge == .left ? .trailing : .leading
        } else {
            return edge == .left ? .leading : .trailing
        }
    }
    
    func body(content: Content) -> some View {
        content
            .padding(computedEdge, length)
    }
}

extension View {
    func padding(_ edge: NoFlipEdge, _ length: CGFloat? = nil) -> some View {
        self.modifier(NoFlipPadding(edge: edge, length: length))
    }
}
