import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var networkingManager = NetworkManager(apiBaseURL: "https://yts.mx/api/v2", shouldLoadData: true)
    @StateObject var searchVM = SearchViewModel()
    @State private var showingSheet = false
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    var searchResults: [Movies] {
        if searchVM.searchQuery.isEmpty {
            return networkingManager.movies
        } else {
            if searchVM.searchResults.isEmpty {
                let text = searchVM.searchQuery.trimmed.lowercased()
                let filtered = networkingManager.movies.filter { movie in
                    return (movie.titleLong?.lowercased().contains(text) ?? false) || (movie.descriptionFull?.lowercased().contains(text) ?? false)
                }
                return filtered
            } else {
                return searchVM.searchResults
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    SearchBarView(vm: searchVM)
                    LazyVStack(spacing: 15) {
                        ForEach(searchResults, id: \.id) { movie in
                            SearchListView(movie: movie)
                                .onAppear() {
                                    if searchVM.searchResults.last?.id == movie.id {
                                        searchVM.loadMoreSearchContent(currentItem: movie)
                                        print("Call")
                                    }
                                }
                        }
                    }
                    .padding(16)
                }
                .background(Color(AppColor.Figma.Background))
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(AppColor.Figma.Background))
    }
}
