//
//  CategoryView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct HomeFilter: View {
    let genres = ["🧨 Action", "👻 Horror", "🙀 Thriller", "🔍 Adventure", "🤣 Comedy", "👽 Sci-Fi", "💙 Romance", "🎨 Animation", "📚 Biography", "🔪 Crime", "📝 Documentary", "🎭 Drama", "🏡 Family", "🔮 Fantasy", "📺 Film-Noir", "⏰ History", "🎺 Musical", "❓ Mystery", "⚽️ Sport", "⚠️ War", "🤠 Western"]
    
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var searchVM: SearchViewModel
    @Binding var selectedCategory: String
    
    var body: some View {
        VStack(spacing: 0) {
            filterMenu
            genreScrollView
        }
    }

    private var filterMenu: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                filterButton(label: "Title", filterBy: "title")
                filterButton(label: "Year", filterBy: "year")
                filterButton(label: "Top Rated", filterBy: "rating")
                filterButton(label: "Peers", filterBy: "peers")
                filterButton(label: "Trending", filterBy: "seeds")
                filterButton(label: "Downloads", filterBy: "download_count")
                filterButton(label: "Like Count", filterBy: "like_count")
                filterButton(label: "Latest", filterBy: "date_added")
            }
        }
    }

    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(genres, id: \.self) { genre in
                    Button {
                        selectedCategory = String(genre.dropFirst(2))
                        searchVM.selectedCategory = selectedCategory
                    } label: {
                        CategoryButtonView(category: genre, selectedCategory: $searchVM.selectedCategory)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }

    private func filterButton(label: String, filterBy: String) -> some View {
        Button {
            searchVM.filterBy = filterBy
        } label: {
            LabelView(label: label, selected: searchVM.filterBy == filterBy)
        }
    }
}
