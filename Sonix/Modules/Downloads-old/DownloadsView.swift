//
//  Dashboard.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//


//
//  Download.swift
//  Sonix
//
//  Created by Jake Round on 20/03/2023.
//

import SwiftUI
import Foundation
import Refresher

struct Download: View {
    
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
    }
    
    private var gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    @State var showSheetView1 = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 30) {
                        
                        listingView
                        
                    }
                    .padding()
                    
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
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Downloads")
                .navigationBarHidden(true)
                .sheet(isPresented: $showSheetView1) {
                    SettingsScreen()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(AppColor.BackGround.darkBackground))
            .errorAlert(error: $viewModel.error)
            .fullScreenCover(isPresented: $showVideoPlayer, content: {
                AVPlayerView(videoURL: $videoURL)
                    .edgesIgnoringSafeArea(.all)
            })
        }
        .navigationViewStyle(.stack)
        
    }
    
    
    
    private var listingView: some View {
        
        ForEach(viewModel.datasource) { data in
            
            let label = data.file.name
            let editedText = label.replacingOccurrences(of: ".", with: " ")
            let filetype2 = editedText.replacingOccurrences(of: "mp4", with: "")
            let qualityhigh = filetype2.replacingOccurrences(of: "2480p", with: "")
            let qualitymed = qualityhigh.replacingOccurrences(of: "1080p", with: "")
            let qualitylow = qualitymed.replacingOccurrences(of: "720p", with: "")
            let yts = qualitylow.replacingOccurrences(of: "[YTS MX]", with: "")
            let yify = yts.replacingOccurrences(of: "YIFY", with: "")
            let x264 = yify.replacingOccurrences(of: "x264", with: "")
            let brrip = x264.replacingOccurrences(of: "BrRip", with: "")
            let bluray = brrip.replacingOccurrences(of: "BluRay", with: "")
            let aac5 = bluray.replacingOccurrences(of: "AAC5 1", with: "")
            let webrip = aac5.replacingOccurrences(of: "WEBRip", with: "")
            let dash = webrip.replacingOccurrences(of: "-", with: "")
            let yts1 = dash.replacingOccurrences(of: "[YTS AM]", with: "")
            let space = yts1.replacingOccurrences(of: "  ", with: "")
            let deceit1 = space.replacingOccurrences(of: "Deceit", with: "")
            let firsttry = deceit1.replacingOccurrences(of: "( FIRST TRY)", with: "")
            let x265 = firsttry.replacingOccurrences(of: "x265R", with: "")
            let extended = x265.replacingOccurrences(of: "EXTENDED", with: "")
            let remastered = extended.replacingOccurrences(of: "REMASTERED", with: "")
            let repack = remastered.replacingOccurrences(of: "REPACK", with: "")
            let rip = repack.replacingOccurrences(of: "BRrip", with: "")
            let gb12 = rip.replacingOccurrences(of: "1 29G", with: "")
            let bracker1 = gb12.replacingOccurrences(of: "(", with: "")
            let bracker2 = bracker1.replacingOccurrences(of: ")", with: "")
            let extended12 = bracker2.replacingOccurrences(of: "Extended", with: "")
            
            let proper = extended12.replacingOccurrences(of: "PROPER", with: "")
            let arbg = proper.replacingOccurrences(of: "ARBG", with: "")
            let extended2 = arbg.replacingOccurrences(of: "ARBG", with: "")
            
            //let movieTitle = extended
            
            let string = extended2
            let substring1 = string.dropLast(4)         // removed year from string
            let substring2 = substring1.dropLast()
            
            let str3 = extended2
            
            let year = str3.westernArabicNumeralsOnly
                        
            VStack {
                
                Image("Poster_Image")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .frame(width: 165)
                
                VStack (alignment: .center, spacing: 10){
                    
                    Text(substring2)
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundColor(Color(AppColor.Title.defaultType))
                        .frame(width: 165, alignment: .leading)
                        .lineLimit(1)
                    
                    Text(year)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(Color(AppColor.Title.subType))
                        .frame(width: 165, alignment: .leading)
                    
                }
                .frame(height: 65)
                
            }
            .onTapGesture {
                guard let url = viewModel.getStreamURL(file: data.file) else { return }
                videoURL = url
                showVideoPlayer = true
            }
            
        }
    }
    
}



struct SearchField: View {
    let placeholder: String
    @Binding var value: String
    
    var body: some View {
        TextField(placeholder, text: $value)
            .frame(maxWidth:300)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 13)
                    .stroke(.gray, lineWidth: 1)
            )
            .foregroundColor(
                Color(AppColor.Components.SearchBar.text)
            )
    }
}




extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}


extension Download {
    
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

extension Download {
    struct Constants {
        static let title = "Downloads"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Download"
    }
}

struct Download_Previews: PreviewProvider {
    static var previews: some View {
        Download()
    }
}


