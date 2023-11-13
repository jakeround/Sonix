

//
//  TransferView.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

import SwiftUI


// MARK: - ChillResults
struct ChillSearchDetails: View {
    var result: SearchResult
    
    @StateObject private var viewModel = TransferViewModel()
    @State private var searchValue: String = ""

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text(result.title)
                        .font(.title)
                        .padding(.bottom)
                    
                    Text(result.link)
                        .font(.body)
                        .padding(.bottom)
                        .onTapGesture {
                            self.searchValue = result.link  // Update searchValue with result.link
                            UIPasteboard.general.string = self.result.link
                            print("\(result.link)")
                        }
                    
                    searchBar
                        .onChange(of: searchValue) { newValue in
                                                    if !newValue.isEmpty {
                                                        transferData(hash: newValue)
                                                    }
                                                }
                    downloadButton
                }
                .onAppear(perform: fetchData)
                .frame(minWidth: 350, maxWidth: 700)

                if viewModel.isLoading {
                    ActivityIndicator()
                }
            }
            .navigationTitle(Constants.title)
        }
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
extension ChillSearchDetails {
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

// MARK: - Constants
extension ChillSearchDetails {
    struct Constants {
        static let title = "Sonix"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Download"
    }
}

