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
            HStack(spacing: 10) {
                if let imageURL = movie.mediumCoverImage {
                    AsyncImage(
                        url: URL(string: imageURL),
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(16)
                                .frame(width: 80, height: 120) // Adjust the size as needed
                        },
                        placeholder: {
                            Image("poster")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(16)
                                .frame(width: 80, height: 120) // Adjust the size as needed
                        }
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title ?? "")
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(Color(AppColor.Title.defaultType))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Text will wrap automatically when needed
                    
                    // if let yearText = movie.yearText {
                    //     let year = yearText.replacingOccurrences(of: ",", with: "")
                    //    Text(year)
                    //       .font(.headline)
                    //      .fontWeight(.regular)
                    //      .foregroundColor(Color(AppColor.Title.subType))
                    //     .frame(maxWidth: .infinity, alignment: .leading)
                    //   }
                }
                .padding(.trailing, 10) // Add some trailing padding to the text
            }
            .padding(10) // Add padding to the entire HStack
        }
    }
}



