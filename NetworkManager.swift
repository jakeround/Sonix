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
    var sortby = "year"
    
    init() {
        loadData()
    }
    
   //MARK: - PAGINATION
    func loadMoreContent(currentItem item: Movies) {
            currentPage += 1
            loadData()
    }
    
    
    
    //MARK: - API CALL
    func loadData() {

        let url = URL(string: "https://yts.torrentbay.to/api/v2/list_movies.json?sort_by=\(self.sortby)&page=\(self.currentPage)")!
        
           URLSession.shared.dataTask(with: url) { (data, response, error) in

               if(error == nil && data != nil)
               {
                   do {
                       let result = try JSONDecoder().decode(ApiResponse.self, from: data!)

                       DispatchQueue.main.async {
                           self.movies.append(contentsOf: result.data?.movies ?? [])

                           print("Page: \(self.currentPage)")
                       }

                   } catch let error {

                       debugPrint(error)
                   }
               }

           }.resume()


       }
}
