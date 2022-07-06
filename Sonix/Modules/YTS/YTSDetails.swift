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
    
    @State private var array = [1, 1, 2]

        func doSomething(index: Int) {
            self.array = [1, 2, 3]
        }
    
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
                
                            VStack (alignment: .leading){
                                        Text(movie.genre)
                                            .font(.body)
                                            .foregroundColor(Color(.gray))
                                            .multilineTextAlignment(.center)
                            }
                
                            HStack {
                                Text(movie.duration)
                                    .padding()
                                //Text(movie.year!)
                                  //  .padding()
                                Text(movie.language!.uppercased())
                            }
            
                

                

                
                VStack {
         
                        NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!)) {
                            Text("Trailer")
                        }.font(.system(size: 18, weight: .bold, design: .default))
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 54)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                        .background(Color.primary)
                        .cornerRadius(13)
                  
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
