//
//  CategoryView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct GenresList: View {
    let genres = ["🧨 Action", "👻 Horror", "🙀 Thriller", "🔍 Adventure", "🤣 Comedy", "👽 Sci-Fi", "💙 Romance", "🎨 Animation", "📚 Biography", "🔪 Crime", "📝 Documentary", "🎭 Drama", "🏡 Family", "🔮 Fantasy", "📺 Film-Noir", "⏰ History", "🎺 Musical", "❓ Mystery", "⚽️ Sport", "⚠️ War", "🤠 Western",]

    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var searchVM: SearchViewModel
    @Binding var selectedCategory: String
    
    

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
    
    var names : [String] = ["1", "2" ,"3","4","5","6","7","8","9"]
    var colors: [Color] = [.red, .gray, .green, .yellow, .blue]
    
    
    var body: some View {
        VStack (spacing: 0) {
        
            //VStack{
             //           ForEach(Array(genres.enumerated()), id: \.offset) { index, element in
             //               Text(element)
             //                   .background(colors[safe: index] ?? colors[safe: index - colors.count])
            //            }
             //       }
     
            ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
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
                        .padding(8)
                    }
        
        
        

        .padding(.top, 16)
        .padding(.bottom, 16)
        
    }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
