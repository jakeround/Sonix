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
       // NavigationView {
        ZStack {
            ScrollView {
            VStack {
        AsyncImage(
                        url: URL(string: movie.mediumCoverImage!),
                        content: { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 //.resizable()
                                 .scaledToFit()
                                 .cornerRadius(10)
                                 .frame(width: 150)
                        },
                        placeholder: {
                            Image("poster")
                        }
                    )
        Text(movie.title ?? "")
                HStack {
                if movie.torrents != nil {
               
                    ForEach(movie.torrents!) { torrent in
                       TorrentView(torrent: torrent)
                            .padding(.bottom)
                    }
                }
                }
                NavigationLink {
                    YouTubeTrailer(trailer: movie.ytTrailerCode ?? "")
                } label: {
                    Text("Trailer")
                        .padding()
                        .background(Color(.gray))
                        .cornerRadius(10)
                }
                
               
                        Menu("Play") {
                           
                            Button("Adjust Order", action: adjustOrder)
                            Button("Cancel", action: cancelOrder)
                        }
                    

                
                    
        
        //Text(movie.descriptionFull ?? "")
       // Text(movie.backgroundImage ?? "")
        //Text(movie.year ?? "")
        //Text(movie.url ?? "")
        //Text(movie.state ?? "")
        
        Text("Youtube: \(movie.ytTrailerCode ?? "")")
        Text("IMDB: \(movie.imdbCode ?? "")")
        Text("Language: \(movie.language ?? "")")
        Text("Summary: \(movie.summary ?? "")")
            //.frame(width: 768)
        //Text("Background Image: \(movie.backgroundImage ?? "")")
        //Text("Original: \(movie.backgroundImageOriginal ?? "")")
        
        //Image(movie.backgroundImageOriginal ?? "")
        //Text(movie.id ?? "")
        
        }
            .padding()
       
    }
           // .fullBackground(imageName: movie.backgroundImageOriginal ?? "")
        }
       // }
    }
       
    
    
}


func placeOrder() {
    UIPasteboard.general.string = "Hello world"
}
func adjustOrder() {
    
}
func cancelOrder() {
    
}



public extension View {
    func fullBackground(imageName: String) -> some View {
       return background(
        
        
        AsyncImage(url: URL(string: imageName))
        
        
        
        
                
       )
    }
}
