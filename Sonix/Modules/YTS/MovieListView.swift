//
//  MovieListView.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI

struct MovieListView: View {
    let movie: Movies
    
    var body: some View {
        
        VStack(spacing: 10) {
            if movie.largeCoverImage != nil {
                //AsyncImage(url: URL(string: movie.mediumCoverImage!))
                
                
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
                                        .aspectRatio(contentMode: .fit)
                                        //.resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                        .frame(width: 150)
                                }
                            )
            }
            
            
            
            Text(movie.title ?? "")
                .multilineTextAlignment(.center)
                .frame(height: 45)
                .lineLimit(3)
            
              
            
            
            //if movie.synopsis != nil {
            //    Text(movie.synopsis!)
            //        .multilineTextAlignment(.center)
            //
            //}
     
            //if movie.imdbCode != nil {
               // HStack {
               //     Text("**IMDB:** \(movie.imdbCode ?? "")")
               //     Spacer()
                //}
                
            //}
            
        }
        //.background(Color(blue))
        .frame(width: 150)
            
        
        
    }
}
