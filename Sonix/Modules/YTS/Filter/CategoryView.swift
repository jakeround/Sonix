//
//  CategoryView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct CategoryView: View {
    let genres = ["๐งจ Action", "๐ป Horror", "๐ Thriller", "๐ Adventure", "๐คฃ Comedy", "๐ฝ Sci-Fi", "๐ Romance", "๐จ Animation", "๐ Biography", "๐ช Crime", "๐ Documentary", "๐ญ Drama", "๐ก Family", "๐ฎ Fantasy", "๐บ Film-Noir", "โฐ History", "๐บ Musical", "โ Mystery", "โฝ๏ธ Sport", "โ ๏ธ War", "๐ค  Western",]

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
                            searchVM.filterBy = "seeds"
                        } label: {
                            LabelView(label: "Trending", selected: searchVM.filterBy == "seeds" ? true : false)
                        }
                        
                        // IMDB RATING
                            Button {
                                searchVM.filterBy = "rating"
                            } label: {
                                LabelView(label: "Top Rated", selected: searchVM.filterBy == "rating" ? true : false)
                            }
                        
                        Button {
                            searchVM.filterBy = "date_added"
                        } label: {
                            LabelView(label: "Latest", selected: searchVM.filterBy == "date_added" ? true : false)
                        }

                        Button {
                            searchVM.filterBy = "year"
                        } label: {
                            LabelView(label: "Year", selected: searchVM.filterBy == "year" ? true : false)
                        }
                        
                        Button {
                            searchVM.filterBy = "download_count"
                        } label: {
                            LabelView(label: "Downloads", selected: searchVM.filterBy == "download_count" ? true : false)
                        }
                        
                        
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
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
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}

