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

        NavigationView {

            TabView(selection: $selectedTab) {
                VStack {
                    Home()
                }
                .tabItem {
                    selectedTab == 0 ? Image("Home.Fill") : Image("Home")
                    Text("Home")
                }
                .tag(0)
                
                //VStack {
                //    Genres()
                //}
                //.tabItem {
                //    selectedTab == 1 ? Image("Genres.Fill") : Image("Genres")
                //    Text("Genres")
                //}
                //.tag(1)
                
                //VStack {
                //    Upcoming()
               // }
                //.tabItem {
                //    selectedTab == 2 ? Image("Upcoming.Fill") : Image("Upcoming")
                //    Text("Upcoming")
                //}
                //.tag(2)
                
                VStack {
                    Downloads()
                }
                .tabItem {
                    selectedTab == 3 ? Image("Downloads.Fill") : Image("Downloads")
                    Text("Downloads")
                }
                .tag(3)
                VStack {
                    SearchView()
                }
                .tabItem {
                    selectedTab == 4 ? Image("Search.Fill") : Image("Search")
                    Text("Search")
                }
                .tag(4)
            }
            .accentColor(.green)
            
            .onAppear {
                UITabBar.appearance().barTintColor = .white
            }
        }
    }
}




