//
//  CloudFiles.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI
import Foundation
import Refresher

struct CloudFiles: View {
    
    //init() {
            //Use this if NavigationBarTitle is with Large Font
            //UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]

            //Use this if NavigationBarTitle is with displayMode = .inline
            //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
       // }
    
    struct SharesheetURL: Identifiable {
        let id: String
        let url: URL
    }
    
    @StateObject var viewModel = TransferViewModel()
    
    @State var showVideoPlayer: Bool = false
    @State var videoURL: URL? = nil
    @State var sharesheetData: SharesheetURL?
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Arial", size: 30)!]
        
        //Font not correct for page title
       
    }
    
    private var gridItems = [
        GridItem(.flexible())
    ]
    
    
  
    
    @State var showSheetView1 = false

    var body: some View {
        
        
        
        NavigationView {
            VStack {
                
                ScrollView {
                    
                    VStack(spacing: 0) {
                        listingView
                    }
                    .padding(.top, 16)
                   
                    
                    .onAppear {
                        self.fetchData()
                        self.refreshData()
                    }
                }
                
                
                .refresher(style: .system) { done in // Called when pulled to refresh
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.fetchData()
                        done() // Stops the refresh view (can be called on a background thread)
                    }
                }
        
            
                
            }
            .background(Color(AppColor.Figma.Background))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(AppColor.BackGround.darkBackground))
            .errorAlert(error: $viewModel.error)
            .fullScreenCover(isPresented: $showVideoPlayer, content: {
                AVPlayerView(videoURL: $videoURL)
                    .edgesIgnoringSafeArea(.all)
            })
        }
        .navigationBarTitle (Text("Files"), displayMode: .inline)
        //.font(.system(size: 18, weight: .bold, design: .rounded))
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(AppColor.Figma.Background))
        //.navigationViewStyle(.stack)
        
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

        return processedLabel
    }

    private var listingView: some View {
        ForEach(viewModel.datasource) { data in
            let processedLabel = processLabel(data.file.name)
            let substring1 = String(processedLabel.dropLast(4).dropLast())
            
            VStack {
                HStack {
                    Text(substring1)
                    Spacer()
                    Image("Link")
                        .onTapGesture() {
                            print(viewModel.getStreamURL(file: data.file))
                            // Copy to clipboard currently broken
                            //UIPasteboard.general.string = viewModel.getStreamURL(file: data.file)
                        }
                }
                .padding(16)
                .background(Color(AppColor.Figma.Card))
                .foregroundColor(Color(AppColor.Figma.TitleText))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .cornerRadius(16)
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)) // Apply custom padding values
            .onTapGesture {
                guard let url = viewModel.getStreamURL(file: data.file) else { return }
                videoURL = url
                showVideoPlayer = true
            }
        }
    }

    
}










extension CloudFiles {
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func refreshData() {
        viewModel.refreshData()
    }
        
    func getShareURL(file: PutioKitSearchFile) {
        if let shareURL = file.shareURL {
            sharesheetData = SharesheetURL(id: UUID().uuidString, url: shareURL)
        } else {
            viewModel.generateShareURL(file: file.file) { shareURL in
                sharesheetData = SharesheetURL(id: UUID().uuidString, url: shareURL)
            }
        }
    }
    
}

extension CloudFiles {
    struct Constants {
        static let title = "Downloads"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Download"
    }
}


