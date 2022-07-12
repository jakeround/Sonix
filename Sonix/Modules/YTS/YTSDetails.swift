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
                
                
                
                //RatingView(rating: 3.1)
                printUI(movie.yearText)
                
                //Text(movie.yearText)
                
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
                    Text(movie.mpaRating!)
                        .padding()
                    Text(movie.language!.uppercased())
                    if movie.yearText != nil {
                        let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                        Text(year)
                            .padding()
                            
                        
                    }
                }
            
                

                

                
                VStack {
         
                    NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)) {
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
                                                    RatingsSection
                                                }
                    
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
        .navigationTitle(movie.title!)
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

extension YTSDetails {
    private var RatingsSection: some View {
        HStack(alignment: .center) {
            RatingsBuilder(ratings: movie.rating!)
                .font(.system(size: 24))
            //Text("\(movie.rating, specifier: "%.1f")")
            //.foregroundColor(.yellow)
            //.font(.system(size: 24))
            //.fontWeight(.semibold)
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func RatingsBuilder(ratings: Double) -> some View {
        let percent = ratings * 10
        let stars = (percent + 0.5) / 20
        let rounded = Int(stars.rounded())
        let remainder = Int(5 - rounded)
        
        HStack {
            ForEach(0..<rounded) { _ in
                Image(systemName: "star.fill")
                    .renderingMode(.original)
            }
            ForEach(0..<remainder) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(Color(.systemGray))
            }
        }
    }
}

extension View {
    func printUI(_ args: Any..., separator: String = " ", terminator: String = "\n") -> EmptyView {
        let output = args.map(String.init(describing:)).joined(separator: separator)
        print(output, terminator: terminator)
        return EmptyView()
    }
}
