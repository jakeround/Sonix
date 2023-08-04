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
    //@Binding var isShowingSearchView: Bool
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(AppColor.Figma.Card))
            
                
            
            
            HStack {
            
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(AppColor.Components.SearchBar.icons))
                
                TextField("Search...", text: $vm.searchQuery)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    } // Selects text field without keyboard
                
                    .onReceive(
                        vm.$searchQuery
                            .debounce(for: .milliseconds(1500), scheduler: DispatchQueue.main)
                    ) { guard !$0 .isEmpty else { return }
                        vm.searchMovies(searchText: $0.trimmed)
                        print("Searching for '\($0.trimmed)'")
                    }
                
                    .onChange(of: vm.searchQuery) { _ in
                        vm.searchResults = []
                        vm.searchMovies(searchText: vm.searchQuery)
                        print(vm.searchQuery)
                    }
                
                Spacer()
                
                Button {
                    //isShowingSearchView = false
                    vm.searchQuery = ""
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color(AppColor.Figma.TitleText))
                }
                
                
            }
            .background(Color(AppColor.Figma.Card))
            //.foregroundColor(Color(AppColor.Figma.TitleText))
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .padding(16)
            
            
            
            
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
        
        //.background(Color(.systemBlue))
    }
}

