//
//  Download.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI
import Foundation
import Refresher

struct Downloads: View {
    @State private var showingSheet = false
    @StateObject var viewModel = TransferViewModel()
    @State var showVideoPlayer: Bool = false
    @State var videoURL: URL? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    listingView
                }
                .padding(.top, 16)
                .onAppear {
                    viewModel.fetchData()
                }
                
            }
            .background(Color(AppColor.Figma.Background))
            .navigationBarTitle("Downloads", displayMode: .inline)
            .navigationBarItems(trailing: settingsButton)
            .fullScreenCover(isPresented: $showVideoPlayer) {
                AVPlayerView(videoURL: $videoURL)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(AppColor.Figma.Background))
    }
    
    private var settingsButton: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $showingSheet) {
            SettingsScreen()
        }
    }
    
    private var listingView: some View {
        ForEach(viewModel.datasource) { data in
            let processedLabel = processLabel(data.file.name)
            VStack {
                HStack {
                    Text(processedLabel)
                    Spacer()
                    Image("Link")
                        .onTapGesture {
                            // Handle tap gesture
                        }
                }
                .padding()
                .background(Color(AppColor.Figma.Card))
                .cornerRadius(16)
                .onTapGesture {
                    guard let url = viewModel.getStreamURL(file: data.file) else { return }
                    videoURL = url
                    showVideoPlayer = true
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func processLabel(_ label: String) -> String {
        var processedLabel = label
        let replacements = [
            (".", " "),
            ("mp4", ""),
            ("2480p", ""),
            ("1080p", ""),
            ("720p", ""),
            ("[YTS MX]", ""),
            ("YIFY", ""),
            ("x264", ""),
            ("BrRip", ""),
            ("BluRay", ""),
            ("AAC5 1", ""),
            ("WEBRip", ""),
            ("-", ""),
            ("[YTS AM]", ""),
            ("  ", ""),
            ("Deceit", ""),
            ("( FIRST TRY)", ""),
            ("x265R", ""),
            ("EXTENDED", ""),
            ("REMASTERED", ""),
            ("REPACK", ""),
            ("BRrip", ""),
            ("1 29G", ""),
            ("(", ""),
            (")", ""),
            ("Extended", ""),
            ("PROPER", ""),
            ("ARBG", "")
        ]
        
        for (search, replace) in replacements {
            processedLabel = processedLabel.replacingOccurrences(of: search, with: replace)
        }
        
        return processedLabel // Ensure this return statement is present
    }
    
}
