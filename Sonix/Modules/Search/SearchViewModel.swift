import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Movies] = []
    @Published var categorizedResults: [Movies] = []
    @Published var selectedCategory = ""
    @Published var filterBy = "download_count"
    @Published var searchQuery = ""
    @Published var currentPage = 1

    // MARK: - PAGINATION
    func loadMoreSearchContent(currentItem item: Movies) {
        currentPage += 1
        searchMovies(searchText: searchQuery)
    }

    func loadMoreCategorizedContent(currentItem item: Movies) {
        currentPage += 1
        searchByCategory()
    }

    // MARK: - LOAD FILTERED RESULTS
    func loadFilteredResults() {
        currentPage = 1 // Reset currentPage when applying filters
        categorizedResults = []
        searchByCategory()
    }

    func searchMovies(searchText: String) {
        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        let urlStr = "https://yts.mx/api/v2/list_movies.json?query_term=\(query)&limit=50&page=\(currentPage)"
        guard let url = URL(string: urlStr) else {
            print("Invalid URL. No movies found for this title")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Filter out duplicate movies by checking if they already exist in searchResults
                        let uniqueMovies = result.data?.movies?.filter { movie in
                            !self.searchResults.contains { $0.id == movie.id }
                        }
                        self.searchResults.append(contentsOf: uniqueMovies ?? [])
                    }
                } catch let error {
                    debugPrint(error)
                }
            }
        }.resume()
    }

    func searchByCategory() {
        let urlStr = "https://yts.mx/api/v2/list_movies.json?genre=\(selectedCategory)&sort_by=\(filterBy)&limit=50&page=\(currentPage)"
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Filter out duplicate movies by checking if they already exist in categorizedResults
                        let uniqueMovies = result.data?.movies?.filter { movie in
                            !self.categorizedResults.contains { $0.id == movie.id }
                        }
                        self.categorizedResults.append(contentsOf: uniqueMovies ?? [])
                    }
                } catch let error {
                    debugPrint(error)
                }
            }
        }.resume()
    }
}
