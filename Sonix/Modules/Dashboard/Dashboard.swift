//
//  Dashboard.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import SwiftUI
import Foundation
import Refresher

struct Dashboard: View {
    
    struct SharesheetURL: Identifiable {
        let id: String
        let url: URL
    }
        
    @StateObject var viewModel = SearchViewModel()
    
    @State var showVideoPlayer: Bool = false
    @State var videoURL: URL? = nil
    @State var sharesheetData: SharesheetURL?

    init() {
        UITableView.appearance().backgroundColor = .clear
    }

    private var gridItems = [GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())]

    
    let columns = [
           GridItem(.adaptive(minimum: 160))
       ]
    
    var body: some View {
        
        
       
        
        
            NavigationView {
                VStack {
                    
                    
                    
                    ScrollView {
                        
                        //HStack {
                        //SearchField(placeholder: Constants.searchBarPlaceholder, value: $viewModel.searchText)
                        
                        //Button {
                        //    self.transferData()
                            //self.fetchData()
                        //} label: {
                        //    if $viewModel.isUploading.wrappedValue {
                        //        ProgressView()
                        //            .tint(Color(AppColor.primaryText))
                        //    } else {
                         //      Text("Transfer")
                          //          .font(.system(size: 16, weight: .bold, design: .default))
                         //   }
                        //}
                        //.buttonStyle(HollowButtonStyle())
                        //}
                        //.padding()
                        
                        LazyVGrid(columns: columns, spacing: 30) {
                        
                       
                        
                       
                        
                        listingView
                            //ZStack {
                            //    if viewModel.isLoading {
                            //        ActivityIndicator()
                             //   }
                           // }
                        
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
                    
                    

                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(AppColor.BackGround.darkBackground))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Constants.title)
                //.toolbar {
                   // Button(action: {
                     //           self.fetchData()
                               // self.refreshData()
                     //       }) {
                     //           Label("Refresh", systemImage: "arrow.clockwise")
                     //       }
                    
               // }
                
                //Button(systemName: "square.and.arrow.up") {
                 //   self.fetchData()
                 //   self.refreshData()
                //}
                
                
                
                .errorAlert(error: $viewModel.error)
                .sheet(isPresented: $showVideoPlayer) {
                    AVPlayerView(videoURL: $videoURL)
                        .edgesIgnoringSafeArea(.all)
                }
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

               //let newStr1 = str1.westernArabicNumeralsOnly
               //let newStr2 = str2.westernArabicNumeralsOnly
               let year = str3.westernArabicNumeralsOnly
               
               let dummyVideo = URL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")
              
               
               NavigationLink(destination: DetailsView.init( title: substring2 + "", fileType: data.file.fileExtension, videoURL: (viewModel.getStreamURL(file: data.file) ?? dummyVideo)!, shareURL: viewModel.getStreamURL(file: data.file) )) {
                   VStack {
                       
                    Image("Poster_Image")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .frame(width: 165)
                       
                       //Text(newStr1) // 1
                       //Text(newStr2) // 20
                       //Text(year) // 12334
                  
                       //Text(viewModel.getStreamURL(file: data.file)!.absoluteString)
                       
                       
                       
                       //Text(editedText)
                       VStack (alignment: .center, spacing: 10){
                           
                           Text(substring2)
                               .font(.system(size: 18))
                               .fontWeight(.regular)
                               .foregroundColor(Color(AppColor.Title.defaultType))
                               .frame(width: 165, alignment: .leading)
                               .lineLimit(1)
                               //.background(Color(.blue))
                           
                           Text(year)
                               .font(.system(size: 16))
                               .fontWeight(.regular)
                               .foregroundColor(Color(AppColor.Title.subType))
                               .frame(width: 165, alignment: .leading)
                           
                           
                           
                           
                    
                       }
                       .frame(height: 65)
                       //.background(.blue)
                   
                       
                   }
               }
                            
           
           }
        }
               
       }
          // .refreshable { move up somewhere
                       //self.refreshData()
                   
        
       
    
    
    
    
    
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


extension Dashboard {
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func refreshData() {
        viewModel.refreshData()
    }
    
    func transferData() {
        viewModel.trasferData()
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

extension Dashboard {
    struct Constants {
        static let title = "Download"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Transfer"
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}


