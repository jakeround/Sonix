

import Foundation

class APIService {
    // Replace with your API base URL
    private let baseURL = "https://next.chill.institute/api/v3"

    // Replace with your actual API token
    private let apiToken = "chill.v3_3ZWFEfB9ZUAxEttoEz6pLYLR"
    private let putioToken = "5GJWSIE7C3OAWQDLQTKZ"

    // Function to authenticate with the API
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/your_authentication_endpoint")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST" // or "GET", depending on the API
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue(putioToken, forHTTPHeaderField: "X-Putio-Token")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
        dataTask.resume()
    }

    func performHealthCheck(completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/healthcheck")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue(putioToken, forHTTPHeaderField: "X-Putio-Token")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data, let result = String(data: data, encoding: .utf8) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }

    func performSearch(query: String, completion: @escaping ([SearchResult]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/search?keyword=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&indexer=bitsearch&filterNastyResults=true")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue(putioToken, forHTTPHeaderField: "X-Putio-Token")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data {
                do {
                    let results = try JSONDecoder().decode([SearchResult].self, from: data)
                    completion(results, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }


    
    
    func fetchTopMovies(completion: @escaping ([MovieSearchResult]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/top-movies")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue(putioToken, forHTTPHeaderField: "X-Putio-Token")

        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data {
                do {
                    let movies = try JSONDecoder().decode([MovieSearchResult].self, from: data)
                    completion(movies, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
}

// SearchResult and other related structures/models should be defined here

struct SearchResult: Codable, Identifiable {
    let id: String
    let title: String
    let source: String
    let link: String
    // Other properties...
}

// Renamed to avoid conflict
struct MovieSearchResult: Codable, Identifiable {
    let id: String
    let imdb_title: String
    let imdb_overview: String
    let source: String
    let seeders: Int
    let poster_url: String
    let link: String
    let imdb_id: String
    // Other properties...
}
