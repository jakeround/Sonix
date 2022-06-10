//
//  YTSDetails.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI

struct YTSDetails: View {
    
    let movie: Movies
    let imageLoader = ImageLoader()
    

    
    
    
    var body: some View {
            ScrollView (.vertical, showsIndicators: true) {
                VStack {
                    
                AsyncImage(
                            url: URL(string: movie.backgroundImageOriginal!)
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "wifi.slash")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: .infinity, height: 300)
                        .background(Color(.systemGray))
                        .clipped()
                        .overlay (HStack(alignment: .bottom) {
                            VStack (alignment: .leading){
                                Spacer()
                                        Text(movie.title!)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.label))
                                            .multilineTextAlignment(.center)
                                        Text(movie.synopsis!)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 600)
                            }
                            .padding()
                            Spacer()
                            VStack {
                                Spacer()
                                Text(movie.duration)
                                Text(movie.language!)
                            }
                            .padding()
                                    })
                    
                } // zstack
                
                VStack {
                    
                    HStack {
                        Text("Description")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Text(movie.descriptionFull!)
                            .multilineTextAlignment(.leading)
                    }
                    //.background(Color(.blue))
                    
                    Divider()
                    
                    HStack {
                    Text("Torrents")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        Spacer()
                    }

                    ScrollView (.horizontal, showsIndicators: true) {
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
        .navigationTitle(movie.title!)
    }
}

