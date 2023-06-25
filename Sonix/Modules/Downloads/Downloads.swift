//
//  Download.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI

struct Downloads: View {
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading){
                    NavigationLink(destination: CloudFiles()) {
                        ButtonView()
                    }
                    Spacer()
                }
            }
            .navigationBarItems(leading:
                                    HStack {
                Text("Downloads")
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
            .background(Color(AppColor.Figma.Background))
        }
        
    }
    
    
    
}

struct ButtonView: View {
    var body: some View {
        HStack {
            Text("Files")
            Spacer()
            Image("File")
        }
        .padding(16)
        
        .frame(minWidth: 375, maxWidth: 430, minHeight: 60, maxHeight: 60, alignment: .leading)
        .background(Color(AppColor.Figma.Card))
        .foregroundColor(Color(AppColor.Figma.TitleText))
        .font(.system(size: 18, weight: .bold, design: .rounded))
        .cornerRadius(16)
        .padding(16)
    }
    
}


