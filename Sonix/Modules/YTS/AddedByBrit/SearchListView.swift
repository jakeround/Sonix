//
//  SearchListView.swift
//  Sonix
//
//  Created by Brittany Rima on 7/8/22.
//

import SwiftUI

struct SearchListView: View {
    let movie: Movies
    
    
    var body: some View {
        NavigationLink(destination: YTSDetails(movie: movie)) {
            HStack(spacing: 10) {
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
                        .fontWeight(.bold)
                        .foregroundColor(Color(AppColor.Title.defaultType))
                        .lineLimit(1)
                       
                    
                    if movie.yearText != nil {
                        let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                        Text(year)
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                            
                        
                    }
                        
                    
                    Spacer()
                }
                .padding()

               
                Spacer()
                
                Image(systemName: "chevron.right")
                    
                
            
            
        }
    }
}
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        YTS()
    }
}
