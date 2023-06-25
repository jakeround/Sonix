//
//  Upcoming.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI

struct Upcoming: View {
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            HStack {
                ScrollView {
                    VStack (alignment: .leading){
                        Text(" ")
                            .frame(width: 430)
                    }
                }
            }
            .background(Color(AppColor.Figma.Background))
            .navigationBarItems(leading:
                                    HStack {
                Text("Upcoming")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                
            }, trailing:
                                    HStack {
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Image("Settings")
                        .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                }
                .sheet(isPresented: $showingSheet) {
                    SettingsScreen()
                }
                
            }
            )
            
        }
    
    }

}
