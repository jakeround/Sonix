//
//  MovieSearchViewModel.swift
//  Sonix
//
//  Created by Brittany Rima on 7/10/22.
//

import Foundation


class MovieSearchViewModel: ObservableObject {
    @Published var searchResults: [Movies] = []
    var currentPage = 1
    @Published var searchText = ""
    
    
    func loadData() {

        let url = URL(string: "https://yts.torrentbay.to/api/v2/list_movies.json?&limit=50&query_term=\(self.searchText)&page=\(self.currentPage)")!
        
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
    
    
}




