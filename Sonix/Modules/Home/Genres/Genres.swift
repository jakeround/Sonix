//
//  Genres.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI

import BottomSheet


struct Genres: View {
    @StateObject var networkingManager = NetworkManager(apiBaseURL: "https://yts.mx/api/v2", shouldLoadData: true)
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
        
        var body: some View {
            NavigationView {
                HStack {
                    ScrollView {
                        VStack (alignment: .leading){
                           
                            GenresList(networkManager: networkingManager, searchVM: searchManager, selectedCategory: $selectedCategory)
                            
                            .onAppear {
                                print("ContentView appeared!")
                            }
                                
                        }
                    }
                }
                .background(Color(AppColor.Figma.Background))
                .navigationBarItems(leading:
                                        HStack {
                    Text("Genres")
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

    }
    
  
    


struct Genres_Previews: PreviewProvider {
    static var previews: some View {
        Genres( )
    }
}

