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
    
    init(shouldLoadData: Bool) {
        if shouldLoadData {
            self.loadData()
        }
    }
    
    //MARK: - PAGINATION
    func loadMoreContent(currentItem item: Movies) {
        currentPage += 1
        loadData()
    }
    
    
    
    
    //MARK: - API CALL
    func loadData() {
        
        let url = URL(string: "https://yts.mx/api/v2/list_movies.json?genre=\(category)&sort_by=\(self.sortby)&limit=50&page=\(self.currentPage)")!
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if(error == nil && data != nil)
            {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data!)
                    print("result movies count = \(result.data?.movies?.count)")
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
