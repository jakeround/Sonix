//
//  APIManager.swift
//  YTDSwiftUI


import Combine
import SwiftUI


class NetworkManager: ObservableObject {
    @Published var movies: [Movies] = []
    
    func loadData() {

       let url = URL(string: "https://yts.torrentbay.to/api/v2/list_movies.json?sort_by=year&page=1")!

           URLSession.shared.dataTask(with: url) { (data, response, error) in

               if(error == nil && data != nil)
               {
                   do {
                       let result = try JSONDecoder().decode(ApiResponse.self, from: data!)
                    
                       DispatchQueue.main.async {
                           self.movies = result.data?.movies ?? []
                       }

                   } catch let error {
                       
                       debugPrint(error)
                   }
               }

           }.resume()


       }
}
