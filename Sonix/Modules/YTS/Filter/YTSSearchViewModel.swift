//
//  YTSSearchViewModel.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI
import Combine


class YTSSearchViewModel: ObservableObject {
    @Published var searchResults: [Movies] = []
    @Published var categorizedResults: [Movies] = []
    @Published var selectedCategory = ""
    @Published var filterBy = "Download_count"

    @Published var searchQuery = ""
    
    var currentPage = 1
    
    
    
    //MARK: - PAGINATION
    func loadMoreSearchContent(currentItem item: Movies) {
             currentPage += 1
            searchMovies(searchText: searchQuery)
     }
    
    func loadMoreCategorizedContent(currentItem item: Movies) {
        currentPage += 1
        searchByCategory()
    }
    
    //MARK: - LOAD FILTERED RESULTS
    func loadFilteredResults() {
        categorizedResults = []
        searchByCategory()
    }
    
    
    
    
    
    func searchMovies(searchText: String) {

        guard let url = URL(string: "https://yts.torrentbay.to/api/v2/list_movies.json?query_term=\(searchText)&limit=50&page=\(self.currentPage)") else {
                print("No movies found for this title")
                return
            }
        
           URLSession.shared.dataTask(with: url) { (data, response, error) in

               if(error == nil && data != nil)
               {
                   do {
                       let result = try JSONDecoder().decode(ApiResponse.self, from: data!)

                       DispatchQueue.main.async {
                           self.searchResults.append(contentsOf: result.data?.movies ?? [])
                           print("Page: \(self.currentPage)")
                       }

                   } catch let error {

                       debugPrint(error)
                   }
               }

           }.resume()
        


       }
    
    func searchByCategory() {
        let url = URL(string: "https://yts.torrentbay.to/api/v2/list_movies.json?genre=\(self.selectedCategory)&sort_by=\(filterBy)&limit=50&page=\(self.currentPage)")!
        
           URLSession.shared.dataTask(with: url) { (data, response, error) in

               if(error == nil && data != nil)
               {
                   do {
                       let result = try JSONDecoder().decode(ApiResponse.self, from: data!)

                       DispatchQueue.main.async {
                           self.categorizedResults.append(contentsOf: result.data?.movies ?? [])
                           print("Page: \(self.currentPage)")
                       }

                   } catch let error {

                       debugPrint(error)
                   }
               }

           }.resume()
        
    }
    
    
}
