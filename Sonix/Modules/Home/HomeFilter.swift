//
//  CategoryView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct HomeFilter: View {
    let genres = ["🧨 Action", "👻 Horror", "🙀 Thriller", "🔍 Adventure", "🤣 Comedy", "👽 Sci-Fi", "💙 Romance", "🎨 Animation", "📚 Biography", "🔪 Crime", "📝 Documentary", "🎭 Drama", "🏡 Family", "🔮 Fantasy", "📺 Film-Noir", "⏰ History", "🎺 Musical", "❓ Mystery", "⚽️ Sport", "⚠️ War", "🤠 Western",]

    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var searchVM: SearchViewModel
    @Binding var selectedCategory: String
    
    var body: some View {
        VStack (spacing: 0) {
        
        VStack (alignment: .trailing, spacing: 4) {
            //MARK: - FILTER MENU
            Spacer()
            
            
            ScrollView (.horizontal) {
                HStack (spacing: 12){
                
                Button {
                    searchVM.filterBy = "title"
                    
                } label: {
                    LabelView(label: "Title", selected: searchVM.filterBy == "title" ? true : false)
                }
                
                
                Button {
                    searchVM.filterBy = "year"
                } label: {
                    LabelView(label: "Year", selected: searchVM.filterBy == "year" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "rating"
                } label: {
                    LabelView(label: "Top Rated", selected: searchVM.filterBy == "rating" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "peers"
                } label: {
                    LabelView(label: "Peers", selected: searchVM.filterBy == "peers" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "seeds"
                } label: {
                    LabelView(label: "Trending", selected: searchVM.filterBy == "seeds" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "download_count"
                } label: {
                    LabelView(label: "Downloads", selected: searchVM.filterBy == "download_count" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "like_count"
                } label: {
                    LabelView(label: "Like Count", selected: searchVM.filterBy == "like_count" ? true : false)
                }
                
                Button {
                    searchVM.filterBy = "date_added"
                } label: {
                    LabelView(label: "Latest", selected: searchVM.filterBy == "date_added" ? true : false)
                }
                
                
            }
            }
            //Spacer()
           
        }
        
        
        
        
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                  
                    
            


                    ForEach(genres, id: \.self) { genre in
                        Button {
                            selectedCategory = String(genre.dropFirst(2))
                            searchVM.selectedCategory = String(genre.dropFirst(2))
//                            networkManager.category = String(genre.dropFirst(2))
            
                        } label: {
                            CategoryButtonView(category: genre, selectedCategory: $searchVM.selectedCategory)
                        }

                        
                        
                           
                            
        
                    }
                    
                }
                    
                
            }
            

        }
        //.padding(.top, 20)
        .padding(.bottom, 24)
        
    }
    }
}

