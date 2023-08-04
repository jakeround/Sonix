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
    
    @State private var showingSheet = false
    
    @State private var isShowingTravelModes = false
    @State private var selectedTravelName = "car.fill"
    
    
    
    var body: some View {
        NavigationView {
            
            
            
            
            ScrollView (.vertical, showsIndicators: false) {
                
                VStack {
                    HomeFilter(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
                }
                
//                ZStack (alignment: .bottomLeading) {
//                    Button("") {
//                        isShowingTravelModes.toggle()
//                    }
//                    .buttonStyle(travelModeButton(systemImageName: selectedTravelName))
//                    .padding(30)
//                    .sheet(isPresented: $isShowingTravelModes) {
//                        if #available(iOS 16.0, *) {
//                            travelOptionView
//                                .presentationDetents([.medium, .large])
//                                .presentationDragIndicator(.visible)
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
//                }
                
                LazyVGrid(columns: columns, spacing: 16) {
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
                
                .padding(16)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
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
            
            
            
            
            //.sheet(isPresented: $showSearchView) {
            //     SearchView(searchVM: searchManager, isShowingSearch: $showSearchView)
            // }
        }
        
        
        
        
        
        //        .navigationViewStyle(StackNavigationViewStyle())
        //
        //        .onChange(of: networkingManager.sortby) { newValue in
        //            networkingManager.movies = []
        //            networkingManager.loadData()
        //        }
        //
        //        .onAppear {
        //            print("ContentView appeared!")
        //        }
        
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
//    var travelOptionView: some View {
//        VStack (spacing: 20) {
//            SearchView()
//        }
//
//
//
//
//
//
//    }
//
//
//    struct travelModeButton: ButtonStyle {
//
//        let systemImageName: String
//
//        func makeBody(configuration: Configuration) -> some View {
//            Image(systemName: systemImageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//                .frame(width: 33, height: 33)
//                .padding()
//                .background(Color.pink)
//                .clipShape(Circle())
//        }
//    }
}
