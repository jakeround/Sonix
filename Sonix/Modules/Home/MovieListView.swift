//
//  MovieListView.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2023.
//

import SwiftUI

struct MovieListView: View {
    let movie: Movies
    @State var showList = false
    @State var showMapSetting = false
    @State private var showingSheet = false
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie)) {
            
            VStack(spacing: 12) {
                ZStack (alignment: .top) {
                    
                    
                    if movie.largeCoverImage != nil {
                        //AsyncImage(url: URL(string: movie.mediumCoverImage!))
                        
                        
                        AsyncImage(
                            url: URL(string: movie.mediumCoverImage!),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                //.resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    //.frame(width: 193, height: 256)
                            },
                            placeholder: {
                                Image("Placeholder")
                                    .aspectRatio(contentMode: .fill)
                                //.resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    //.frame(width: 193, height: 256)
                            }
                        )
                    }
                    
                }
                
                
                VStack (spacing: 8) {
                    Text(movie.title!)
                        .font(Font.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(AppColor.designSystem.headline))
                        .frame(width: 191, alignment: .leading)
                        .lineLimit(1)
                    //.background(Color(.blue))

                }
                VStack {
                    HStack (spacing: 12) {
                        if movie.yearText != nil {
                            let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                            Text(year)
                                .font(Font.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color(AppColor.designSystem.subtext))
                                .frame(width: 67, height: 40)
                                .background(Color(AppColor.Figma.Card))
                                .cornerRadius(12)
                            //.frame(width: 191, alignment: .leading)
                            
                            
                        }
                        
                        if movie.rating != nil {
                            
                            let imdbRating = String(movie.rating!).replacingOccurrences(of: ",", with: "")
                            
                            Text("\(imdbRating)")
                                .font(Font.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color(AppColor.designSystem.white))
                                .padding(.top, 4)
                                .padding(.bottom, 4)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .frame(height: 40)
                            //.padding(8)
                                .background(Color(AppColor.Figma.Card))
                                .cornerRadius(12)
                            
                            //Spacer()
                            
                            //.padding(14)
                            //.background(Color(AppColor.BackGround.cardColour))
                        }
                        Spacer()
                    }
                }
                //if movie.synopsis != nil {
                //    Text(movie.synopsis!)
                //        .multilineTextAlignment(.center)
                //
                //}
                
                
                
            }
            //.onTapGesture {
               // showingSheet.toggle()
           //}
            
            
            
            
            //.sheet(isPresented: $showingSheet) {
            //   MovieDetailsView(movie: movie)
            //}
            
            //}
            
        }
        
    }
}
