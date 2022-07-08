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
                    Label("Browse", systemImage: "tv")
                        .environment(\.symbolVariants, .none)
                }
            //Sheet()
                //.tabItem {
                //    Label("Sheet", systemImage: "filemenu.and.selection")
                //        .environment(\.symbolVariants, .none)
               // }
            Dashboard()
                .tabItem {
                    Label("Downloads", systemImage: "arrow.down.circle")
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
