//
//  SearchBarView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var vm: YTSSearchViewModel
    @Binding var isShowingSearchView: Bool
    
   
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(AppColor.Components.SearchBar.background))
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search...", text: $vm.searchQuery)
        
                    .onReceive(
                        vm.$searchQuery
                            .debounce(for: .milliseconds(800), scheduler: DispatchQueue.main)
                    ) { guard !$0 .isEmpty else { return }
                        vm.searchMovies(searchText: $0)
                        print("Searching for \($0)")

                    }
                      
                    .onChange(of: vm.searchQuery) { _ in
                        vm.searchResults = []
                        vm.searchMovies(searchText: vm.searchQuery)
                        print(vm.searchQuery)
                    }
                    
                   

                    
                   
                Spacer()
                
                Button {
                    isShowingSearchView = false
                    vm.searchQuery = ""
                } label: {
                    Image(systemName: "x.circle")
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
