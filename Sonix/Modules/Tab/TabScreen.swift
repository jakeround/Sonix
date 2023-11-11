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
            }
            .tabItem {
                selectedTab == 0 ? Image("Home.Fill") : Image("Home")
                Text("Home")
            }
            .tag(0)
            
            ZStack {
                SearchView()
            }
            .tabItem {
                selectedTab == 1 ? Image("Search.Fill") : Image("Search")
                Text("Search")
            }
            .tag(1)
            
            ZStack {
                Downloads()
            }
            .tabItem {
                selectedTab == 2 ? Image("Downloads.Fill") : Image("Downloads")
                Text("Downloads")
            }
            .tag(2)
            
            ZStack {
                HealthCheckView()
            }
            .tabItem {
                selectedTab == 3 ? Image("Upcoming.Fill") : Image("Upcoming")
                Text("New Search")
            }
            .tag(3)
                        
            
        }
        .accentColor(Color(AppColor.Components.TabBar.tint))

    }
    
    
    
}



struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
    
    
   
}


