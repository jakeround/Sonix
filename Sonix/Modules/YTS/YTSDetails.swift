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
    
    @State private var oneActive: Bool = false
    @State private var twoActive: Bool = false
    
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

                
                VStack {
                    
                    NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)) {
                            Text("Trailer")
                        }
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .frame(minWidth: 100, maxWidth: 390, minHeight: 54)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                        .background(Color.primary)
                        .cornerRadius(13)
                  
                    }
                    
                            Menu("Select Quality") {
                                if movie.torrents != nil {
                               
                                    ForEach(movie.torrents!) { torrent in
                                       TorrentView(torrent: torrent)
                                            .padding(.bottom)
                                            
                                    }
                                }
                            }
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(minWidth: 100, maxWidth: 390, minHeight: 54)
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                            .background(Color.primary)
                            .cornerRadius(13)

                    HStack {
                    SearchField(placeholder: "Select quality and paste", value: $viewModel.searchText)
                    
                    Button {
                        self.transferData()
                        //self.fetchData()
                    } label: {
                        if $viewModel.isUploading.wrappedValue {
                            ProgressView()
                                .tint(Color(AppColor.primaryText))
                        } else {
                            Text("Download")
                                .font(.system(size: 16, weight: .bold, design: .default))
                        }
                    }
                    .buttonStyle(HollowButtonStyle())
                    }.frame(minWidth: 100, maxWidth: 390)
                    
                    
                .padding(.horizontal)
                
                VStack (spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if movie.yearText != nil {
                        VStack (spacing: 5) {
                                Text("Year")
                                    .textCase(.uppercase)
                                    .font(.system(size: 12, design: .default))
                                let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                                Text(year)
                                .font(.system(size: 22, weight: .bold, design: .default))
                                Text("Release")
                            }
                        .frame(width: 200, height: 100)
                        .background(Color(AppColor.BackGround.cardColour))
                        .cornerRadius(10)
                        }
                        
                        VStack (spacing: 5) {
                                Text("Duration")
                                    .textCase(.uppercase)
                                    .font(.system(size: 12, design: .default))
                                Text(movie.duration)
                                    .font(.system(size: 22, weight: .bold, design: .default))
                                Text("Standard")
                            }
                        .frame(width: 200, height: 100)
                        .background(Color(AppColor.BackGround.cardColour))
                        .cornerRadius(10)
                        
                        VStack (spacing: 5) {
                                Text("Language")
                                    .textCase(.uppercase)
                                    .font(.system(size: 12, design: .default))
                                Text(movie.language ?? "n/a")
                                    .textCase(.uppercase)
                                    .font(.system(size: 22, weight: .bold, design: .default))
                                Text("Original")
                            }
                        .frame(width: 200, height: 100)
                        .background(Color(AppColor.BackGround.cardColour))
                        .cornerRadius(10)
                        
                        VStack (spacing: 5) {
                                Text("Advised")
                                    .textCase(.uppercase)
                                    .font(.system(size: 12, design: .default))
                                Text(movie.mpaRating ?? "n/a")
                                    .textCase(.uppercase)
                                    .font(.system(size: 22, weight: .bold, design: .default))
                                Text("Age")
                            }
                        .frame(width: 200, height: 100)
                        .background(Color(AppColor.BackGround.cardColour))
                        .cornerRadius(10)
                        
                        if movie.rating != nil {
                            VStack (spacing: 5) {
                                Text("Year")
                                    .textCase(.uppercase)
                                    .font(.system(size: 12, design: .default))
                                let imdbRating = String(movie.rating!).replacingOccurrences(of: ",", with: "")
                                Text(imdbRating)
                                .font(.system(size: 22, weight: .bold, design: .default))
                                RatingsSection
                            }
                        .frame(width: 200, height: 100)
                        .background(Color(AppColor.BackGround.cardColour))
                        .cornerRadius(10)
                        }
                    }
                }
                    
                }
                
                VStack (spacing: 16) {
                    
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

                    
                   
                }
                .padding()
                
                                 
            
            
                        
            
        }
            .background(Color(AppColor.BackGround.darkBackground))
        .navigationTitle(movie.title!)
    }
    
    func placeOrder() { }
        func adjustOrder() { }
        func rename() { }
        func delay() { }
        func cancelOrder() { }
    
    
    struct MenuView: View {
        @Binding var oneActive: Bool
        @Binding var twoActive: Bool
        
        var body: some View {
            Menu {
                Button {
                    oneActive = true
                } label: {
                    Text("Option One")
                }
            
                Button {
                    twoActive = true
                } label: {
                    Text("Option Two")
                }
        
            } label: {
                Image(systemName: "ellipsis")
            }
        }
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
                .font(.system(size: 18))
            //Text("\(movie.rating, specifier: "%.1f")")
            //.foregroundColor(.yellow)
            //.font(.system(size: 24))
            //.fontWeight(.semibold)
        }
        //.padding(.vertical)
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
