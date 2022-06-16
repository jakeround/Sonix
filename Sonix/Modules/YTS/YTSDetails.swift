//
//  YTSDetails.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI
import YouTubePlayerKit
import WebKit

struct YTSDetails: View {
    
    let movie: Movies
    @StateObject var viewModel = SearchViewModel()
    //let youTubePlayer: YouTubePlayer = \(movie.trailer?)
    @State private var isShowingWebView: Bool = false
    
    
    var body: some View {
            ScrollView (.vertical, showsIndicators: true) {
                Spacer()
                Spacer()
                
                
                
                AsyncImage(
                                url: URL(string: movie.mediumCoverImage!),
                                content: { image in
                                    image.resizable()
                                         .aspectRatio(contentMode: .fit)
                                         //.resizable()
                                         .scaledToFit()
                                         .cornerRadius(16)
                                         .frame(width: 165)
                                },
                                placeholder: {
                                    Image("poster")
                                        .aspectRatio(contentMode: .fit)
                                        //.resizable()
                                        .scaledToFit()
                                        .cornerRadius(16)
                                        .frame(width: 165)
                                }
                            )
                
                            VStack (alignment: .leading){
                                        Text(movie.title!)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.label))
                                            .multilineTextAlignment(.center)
                            }
                            HStack {
                                Text(movie.duration)
                                    .padding()
                                //Text(movie.year!)
                                  //  .padding()
                                Text(movie.language!.uppercased())
                            }
            
                
                 //ForEach(movie.genres!, id: \.self) { i in
                  //          HStack {
                  //              Text("Genre")
                  //          }
                  //      }
            
                printUI(movie.genres)
                
                        Button(action: {
                            isShowingWebView = true
                        })
                        {
                            Text("Trailer")
                                .padding()
                                        .foregroundColor(.white)
                                        .background(.red)
                                        .cornerRadius(5)
                        }
                        .sheet(isPresented: $isShowingWebView) {
                            Webview(url: movie.trailer)
                        }
                
                HStack {
                SearchField(placeholder: "Torrent Hash", value: $viewModel.searchText)
                
                Button {
                    self.transferData()
                    //self.fetchData()
                } label: {
                    if $viewModel.isUploading.wrappedValue {
                        ProgressView()
                            .tint(Color(AppColor.primaryText))
                    } else {
                        Text("Transfer")
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }
                }
                .buttonStyle(HollowButtonStyle())
                }
            
                                  
                    
                
                
                VStack {
                    
                    HStack {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    
                    HStack {
                        Text(movie.descriptionFull!)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: .infinity,
                          alignment: .topLeading
                        )
                    .padding()
                    .background(Color(AppColor.BackGround.cardColour))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                  
                    
                    HStack {
                    Text("Torrents")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        Spacer()
                    }

                    ScrollView (.horizontal, showsIndicators: false) {
                    HStack (){
                                    if movie.torrents != nil {
                                   
                                        ForEach(movie.torrents!) { torrent in
                                           TorrentView(torrent: torrent)
                                                .padding(.bottom)
                                        }
                                    }
                                    }
                    }
                }
                .padding()
                
                                 
            
            
                        
            
        }
        //.navigationTitle(movie.title!)
    }
    
    
}

extension YTSDetails {
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func refreshData() {
        viewModel.refreshData()
    }
    
    func transferData() {
        viewModel.trasferData()
    }
    
    
}


extension View {
    func printUI(_ args: Any..., separator: String = " ", terminator: String = "\n") -> EmptyView {
        let output = args.map(String.init(describing:)).joined(separator: separator)
        print(output, terminator: terminator)
        return EmptyView()
    }
}
