//
//  TabScreen.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import SwiftUI

struct TabScreen: View {
    
    var body: some View {
        
        TabView {
            YTS()
                .tabItem {
                    Label("Movies", systemImage: "filemenu.and.selection")
                        .environment(\.symbolVariants, .none)
                }
            Dashboard()
                .tabItem {
                    Label("Download", systemImage: "folder")
                        .environment(\.symbolVariants, .none)
                    
                }
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                        .environment(\.symbolVariants, .none)
                }
        }
        .accentColor(Color(AppColor.Components.TabBar.tint))
        
    }
    
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}
