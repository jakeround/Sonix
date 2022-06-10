//
//  YTSDetails.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI

struct YTSDetails: View {
    
    let movie: Movies

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
                                Text(movie.language!)
                            }
                                  
                    
                
                
                VStack {
                    
                    HStack {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(width: .infinity)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    HStack {
                        Text(movie.descriptionFull!)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color(AppColor.BackGround.cardColour))
                    .cornerRadius(10)
                    
                    
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
        .navigationTitle(movie.title!)
    }
}

