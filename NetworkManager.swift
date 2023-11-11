//
//  NetworkManager.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var movies: [Movies] = []
    var currentPage: Int = 1
    @Published var sortby: String = "download_count"
    @Published var category: String = ""

    // Make apiBaseURL a published property
    @Published var apiBaseURL: String

    init(apiBaseURL: String, shouldLoadData: Bool) {
        self.apiBaseURL = apiBaseURL

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
        // Construct the full URL using the API base URL
        let fullURLString = "\(apiBaseURL)/list_movies.json?genre=\(category)&sort_by=\(self.sortby)&limit=50&page=\(self.currentPage)"
        
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL. Cannot load data.")
            return
        }

        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print("result movies count = \(result.data?.movies?.count)")
                    DispatchQueue.main.async {
                        self.movies.append(contentsOf: result.data?.movies ?? [])
                        print("Page: \(self.currentPage)")
                    }
                } catch let error {
                    debugPrint(error)
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    // Method to update the API base URL
    func updateApiBaseURL(to newURL: String) {
        // Here you can add validation for the URL
        self.apiBaseURL = newURL
        // Reset page count and reload data
        self.currentPage = 1
        self.movies.removeAll()
        loadData()
    }
}

