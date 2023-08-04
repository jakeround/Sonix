//
//  TabScreen.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import SwiftUI

struct TabScreen: View {
    
    @State private var selectedTab = 0
    
    
    
    
    
    var body: some View {

        TabView(selection: $selectedTab) {
            ZStack {
                Home()
                BannerView()
            }
            .tabItem {
                selectedTab == 0 ? Image("Home.Fill") : Image("Home")
                Text("Home")
            }
            .tag(0)
            
            ZStack {
                Downloads()
                BannerView()
            }
            .tabItem {
                selectedTab == 1 ? Image("Downloads.Fill") : Image("Downloads")
                Text("Downloads")
            }
            .tag(1)

            
//            ZStack {
//                SearchView()
//                BannerView()
//            }
//            .tabItem {
//                selectedTab == 2 ? Image("Search.Fill") : Image("Search")
//                Text("Search")
//            }
//            .tag(2)
            
            
        }
        .accentColor(Color(AppColor.Components.TabBar.tint))

    }
    
    struct BannerView : View {
        
        //var text : String
        
        @State private var isShowingTravelModes = false
        
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(AppColor.Components.SearchBar.icons))
                        Text("Search")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    //.padding(12)
                    .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:40)
                            .background(Color.blue)
                            .cornerRadius(16)
                            .padding(8)
                            
                            //.padding()
                    
                    .sheet(isPresented: $isShowingTravelModes) {
                                            if #available(iOS 16.0, *) {
                                                SearchView()
                                                    .presentationDetents([.large])
                                                    .presentationDragIndicator(.visible)
                                            } else {
                                                // Fallback on earlier versions
                                            }
                                        }
                    
                    Spacer()
                }
                .frame(height:72)
                .background(Color(AppColor.Figma.searchSheet), in: RoundedRectangle(cornerRadius: 20))
                .background(content: { Color(AppColor.Figma.searchSheet).padding(.top, 20) })
                //.background(Color(AppColor.Figma.searchSheet))
                
                   // .accentColor(Color(AppColor.Components.TabBar.tint))
            }
            .onTapGesture {
                isShowingTravelModes.toggle()
            }
        }
    }
    
}



struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
    
    
   
}


