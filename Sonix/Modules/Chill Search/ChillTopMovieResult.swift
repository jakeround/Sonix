//
//  TopMovieResults.swift
//  Sonix
//
//  Created by Jake Round on 13/11/2023.
//

import SwiftUI


struct ChillTopMovieResult: View {
    let movie: MovieSearchResult
    
    //var result: SearchResult
    
    @StateObject private var viewModel = TransferViewModel()
    @State private var searchValue: String = ""

    var body: some View {
        VStack {
            if let posterURL = URL(string: movie.poster_url) {
                AsyncImage(url: posterURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
                .padding(.bottom, 5)
            }
            
            Text(movie.imdb_title)
                .font(.title)
            Text(movie.imdb_overview)
                .font(.subheadline)
            Text(movie.imdb_id)
                .font(.subheadline)
            Spacer()
            
            //searchBar
                
            //downloadButton
            
            Text(movie.link)
                .onTapGesture {
                    self.searchValue = movie.link  // Update searchValue with result.link
                    UIPasteboard.general.string = self.movie.link
                    //print("\(movie.link)")
                }
                .onChange(of: searchValue) { newValue in
                                            if !newValue.isEmpty {
                                                transferData(hash: newValue)
                                            }
                                        }
                .font(.body)
            
            
            // Add more details as needed
            
            
        }
        .onAppear(perform: fetchData)
        .padding()
        .navigationTitle(movie.imdb_title)
    }
    // MARK: - Subviews
    private var searchBar: some View {
        SearchField(placeholder: Constants.searchBarPlaceholder, value: $searchValue)
            .padding()
    }

    private var downloadButton: some View {
        Button(action: {
            transferData(hash: searchValue)  // searchValue now contains result.link if tapped
        }) {
            Text(Constants.transfer)
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    // MARK: - Private Methods
    private func fetchData() {
        viewModel.fetchData()
    }

    private func transferData(hash: String) {
        viewModel.downloadMovie(hash: hash) { url in
            // Handle the download
        }
    }
}


// MARK: - SearchField
extension ChillTopMovieResult {
    struct SearchField: View {
        let placeholder: String
        @Binding var value: String

        var body: some View {
            TextField(placeholder, text: $value)
                .padding()
                .background(Color(AppColor.Components.SearchBar.background).cornerRadius(10))
                .foregroundColor(Color(AppColor.Components.SearchBar.text))
        }
    }
}


extension ChillTopMovieResult {
    struct Constants {
        static let title = "Sonix"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Download"
    }
}
