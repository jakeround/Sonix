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
    @ObservedObject var vm: YTSSearchViewModel
    //@Binding var isShowingSearchView: Bool
    
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(AppColor.Components.SearchBar.background))
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search...", text: $vm.searchQuery)

                
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
                }
                
                
            }
            .foregroundColor(Color(AppColor.Components.SearchBar.text))
            .padding(13)
            
            
            
            
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView()
//            .preferredColorScheme(.light)
//    }
//}
