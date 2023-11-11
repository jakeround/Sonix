//
//  SearchBarView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

extension Data {
    func getUTF8EncodedString() -> String? {
        return String(bytes: self, encoding: .utf8)
    }
    func getJson() -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            return json
        } catch {
            return nil
        }
    }
}
extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}

struct SearchBarView: View {
    @ObservedObject var vm: SearchViewModel
    @State private var searchText = ""

    var body: some View {
        Spacer()
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search...", text: $vm.searchQuery)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .disableAutocorrection(true)
                    .onReceive(
                        vm.$searchQuery
                            .debounce(for: .milliseconds(1500), scheduler: DispatchQueue.main)
                    ) { query in
                        let trimmedQuery = query.trimmed
                        guard !trimmedQuery.isEmpty else { return }
                        vm.searchMovies(searchText: trimmedQuery)
                        print("Searching for '\(trimmedQuery)'")
                    }
                    .onChange(of: vm.searchQuery) { _ in
                        vm.searchResults = []
                        let trimmedQuery = vm.searchQuery.trimmed
                        vm.searchMovies(searchText: trimmedQuery)
                        print(trimmedQuery)
                    }

                if !vm.searchQuery.isEmpty {
                    Button {
                        vm.searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}
