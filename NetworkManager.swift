import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var movies: [Movies] = []
    var currentPage: Int = 1
    @Published var sortby: String = "download_count"
    @Published var category: String = ""

    @Published var apiBaseURL: String

    init(shouldLoadData: Bool) {
        // Fetch the API base URL from UserDefaults or use a default value
        self.apiBaseURL = UserDefaults.standard.string(forKey: "apiBaseURL") ?? "https://yts.mx/api/v2/"

        if shouldLoadData {
            self.loadData()
        }
    }

    // MARK: - PAGINATION
    func loadMoreContent(currentItem item: Movies) {
        currentPage += 1
        loadData()
    }

    // MARK: - API CALL
    func loadData() {
        let fullURLString = "\(apiBaseURL)/list_movies.json?genre=\(category)&sort_by=\(self.sortby)&limit=50&page=\(self.currentPage)"
        
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL. Cannot load data.")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movies.append(contentsOf: result.data?.movies ?? [])
                        print("Page: \(self.currentPage)")
                    }
                } catch {
                    print("Error parsing data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func updateApiBaseURL(to newURL: String) {
        UserDefaults.standard.set(newURL, forKey: "apiBaseURL")
        self.apiBaseURL = newURL
        self.currentPage = 1
        self.movies.removeAll()
        loadData()
    }
}
