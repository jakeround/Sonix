//
//  SearchListView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct SearchListView: View {
    let movie: Movies
    
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie)) {
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
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(movie.title!)
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundColor(Color(AppColor.Title.defaultType))
                        .frame(width: 165, alignment: .leading)
                        .lineLimit(1)
                        //.background(Color(.blue))
                    
                    if movie.yearText != nil {
                        let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                        Text(year)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .foregroundColor(Color(AppColor.Title.subType))
                            .frame(width: 165, alignment: .leading)
                            
                        
                    }
                        
                    
                   // Spacer()
                }
               // .padding()

               
                
                    
                
            
            
        }
    }
}
}


