//
//  CategoryView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct CategoryView: View {
    let genres = ["🤣 Comedy", "👽 Sci-Fi", "👻 Horror", "🧨 Action", "🙀 Thriller", "♥️ Romance", "👽 Adventure", "🎨 Animation", "♥️ Biography", "🔪 Crime", "📝 Documentary", "🎭 Drama", "🏡 Family", "🔮 Fantasy", "📺 Film-Noir", "🔦 History", "🎶 Musical", "❓ Mystery", "⚽️ Sport", "⚠️ War", "🤠 Western",]

    @ObservedObject var networkManager: NetworkManager

    @ObservedObject var searchVM: YTSSearchViewModel
    @Binding var selectedCategory: String

   

    
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                  
                    
                    //MARK: - FILTER MENU
                    Menu {
                        //
                        Button {
                        
//                            networkManager.sortby = "date_added"
                            searchVM.filterBy = "date_added"
                            
                        } label: {
                            LabelView(label: "Latest", selected: searchVM.filterBy == "date_added" ? true : false)
                        }
                    // SEEDS
                        Button {
                            // filter by SEEDS
                      
//                            networkManager.sortby = "seeds"
                            searchVM.filterBy = "seeds"
                        } label: {
                            LabelView(label: "Seeds", selected: searchVM.filterBy == "seeds" ? true : false)
                        }
                        
                    // YEAR
                        Button {
                            // filter by YEAR
           
//                            networkManager.sortby = "year"
                            searchVM.filterBy = "year"
                        } label: {
                            LabelView(label: "Year", selected: searchVM.filterBy == "year" ? true : false)
                        }
                        
                    // IMDB RATING
                        Button {
                            // filter by IMDB
    
//                            networkManager.sortby = "rating"
                            searchVM.filterBy = "rating"
                        } label: {
                            LabelView(label: "Rating", selected: searchVM.filterBy == "rating" ? true : false)
                        }
                        
                    // DOWNLOADS
                        Button {
                            // filter by DOWNLOADS
                          
//                            networkManager.sortby = "download_count"
                            searchVM.filterBy = "download_count"
                        } label: {
                            LabelView(label: "Downloads", selected: searchVM.filterBy == "download_count" ? true : false)
                        }
                        
                        
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "line.3.horizontal.circle")
                            Text("Filter")
                        }
                       
                        .font(.headline.bold())
                        .padding()
                        .background(Color(AppColor.Components.ThemeButton.filter))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                   


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
        
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView(selectedButton: <#Binding<String>#>)
//    }
//}
