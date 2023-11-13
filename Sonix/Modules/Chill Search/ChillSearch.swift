
import SwiftUI

struct ChillSearch: View {
    @State private var healthCheckResult: String = "Checking..."
    @State private var isError: Bool = false
    
    @State private var searchText = ""
    private var apiService = APIService()
    
    @State private var searchResults: [SearchResult] = []
    @State private var topMovies: [MovieSearchResult] = [] // If the API returns MovieSearchResult objects
    
    @State private var isLoading = false
    @State private var hasSearched = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    //Text("API Health Check")
                    //   .font(.headline)
                    //  .padding(.vertical) // Adjust padding as needed
                    
                    //Text(healthCheckResult)
                    //   .font(.body)
                    //  .foregroundColor(isError ? .red : .green)
                    //  .onAppear(perform: performHealthCheck)
                    // .padding(.bottom, 5) // Adjust bottom padding
                    
                    searchField
                        .padding(.bottom, 5) // Adjust bottom padding
                    
                    Button("Search", action: performSearch)
                        .padding(.bottom, 10) // Adjust bottom padding
                    
                    if !hasSearched {
                        Text("Trending")
                            .font(.title)
                        ForEach(topMovies) { movie in
                            NavigationLink(destination: ChillTopMovieResult(movie: movie)) {
                                HStack {
                                    if let posterURL = URL(string: movie.poster_url) {
                                        AsyncImage(url: posterURL) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 85, height: 135)
                                        .cornerRadius(8)
                                    }

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(movie.imdb_title)
                                            .font(.headline)
                                        //Text(movie.imdb_overview)
                                           // .font(.subheadline)
                                           // .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding(.leading, 10) // Add padding to align text to the left

                                    Spacer() // This pushes everything to the left
                                }
                                .frame(maxWidth: .infinity) // Ensure it takes the full width
                                .padding()
                                .background(Color(AppColor.Figma.Card))
                                .cornerRadius(8)
                            }

                        }

                                        }
                
                    if isLoading {
                        Spacer() // Pushes everything below to the middle
                        HStack {
                            Spacer() // Pushes ProgressView to the center
                            ProgressView()
                            Spacer() // Ensures the ProgressView stays centered
                        }
                        Spacer() // Continues to push the ProgressView to the center
                    } else {
                        ForEach(searchResults) { result in
                            NavigationLink(destination: ChillSearchDetails(result: result)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(formatTitle(result.title))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(Color(AppColor.Figma.Card))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                }
                .padding([.horizontal, .bottom])
            }
            .background(Color(AppColor.Figma.Background))
            .onAppear(perform: fetchTopMovies)
            .navigationBarItems(leading:
                                    HStack {
                Text("Search")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
            )
        }
        
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .disableAutocorrection(true)
            //.onChange(of: searchText) { _ in performSearch() }
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                    self.hasSearched = false  // Reset hasSearched when clearing the search field
                   // self.searchResults = []  // Optionally clear the existing search results
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.secondary)
        .background(Color(AppColor.Figma.Card))
        .cornerRadius(10.0)
    }
    
    private func performHealthCheck() {
        apiService.performHealthCheck { result, error in
            DispatchQueue.main.async {
                if let result = result {
                    healthCheckResult = "Result: \(result)"
                } else if let error = error {
                    healthCheckResult = "Error: \(error.localizedDescription)"
                    isError = true
                }
            }
        }
    }
    
    
    
    private func performSearch() {
        hasSearched = true
        isLoading = true // Start loading
        apiService.performSearch(query: searchText) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.searchResults = results
                } else if let error = error {
                    // Handle the error if needed
                }
                isLoading = false // Stop loading
            }
        }
    }
    
    
    private func formatTitle(_ title: String) -> String {
        let components = title.split(separator: ".")
        let filteredComponents = components.filter {
            let componentStr = String($0)
            return !componentStr.isNumber
        }
        
        let capitalizedComponents = filteredComponents.map { String($0).capitalizingFirstLetter() }
        
        return capitalizedComponents.joined(separator: " ")
    }
    
    private func fetchTopMovies() {
        isLoading = true
        apiService.fetchTopMovies { results, error in
            DispatchQueue.main.async {
                isLoading = false
                if let results = results {
                    topMovies = results
                } else if let error = error {
                    isError = true
                    print("Error fetching top movies: \(error)")
                }
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

