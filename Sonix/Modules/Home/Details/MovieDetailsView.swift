//
//  YTSDetails.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI

struct MovieDetailsView: View {
    
    let movie: Movies
    @StateObject var viewModel = TransferViewModel()
    @State private var isShowingWebView: Bool = false
    
    @State private var oneActive: Bool = false
    @State private var twoActive: Bool = false
    
    @State private var showingSheet = false
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var trailerURL: String = ""
    @State var showTrailerPlayer: Bool = false
    
    @State var streamURL: URL? = nil
    @State var showMoviePlayer: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
            
        
        
    
        
        ZStack {
            
            
            
            ScrollView {
                VStack (spacing: 16) {
                    
                     
                    
                        
                    
                    HStack {
                        YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)
                       
                        
                    }
                    //.padding(16)
                    
                    .frame(minWidth: 375, maxWidth: 430, minHeight: 223, maxHeight: 240, alignment: .leading)
                    .background(Color(AppColor.Figma.Card))
                    .foregroundColor(Color(AppColor.Figma.TitleText))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .cornerRadius(16)
                    .padding(.top, 20)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        if movie.rating != nil {
                                            HStack (spacing: 8) {
                                                let imdbRating = String(movie.rating!).replacingOccurrences(of: ",", with: "")
                                                Image("IMDB")
                                                HStack {
                                                    Text("\(imdbRating) / 10")
                                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                                        .foregroundColor(.gray)
                                                    //RatingsSection
                                                }
                                                
                                            }
                                            .frame(width: 108, height: 40)
                                            .padding(.leading, 8)
                                            .padding(.trailing, 16)
                                            .padding(.top, 0)
                                            .padding(.bottom, 0)
                                            .background(Color(AppColor.Figma.Card))
                                            .cornerRadius(12)
                                        }
                                        
                                    
                                            HStack (spacing: 8) {
                                                Image("Clock")
                                                Text(movie.duration)
                                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                                //.foregroundColor(UIColor.AppColor.Figma.movieDetailsInfo)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(height: 40)
                                            .padding(.leading, 8)
                                            .padding(.trailing, 16)
                                            .background(Color(AppColor.Figma.Card))
                                            .cornerRadius(12)
                                        
                                        
                                        if movie.yearText != nil {
                                            VStack (spacing: 5) {
                                                let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                                                Text(year)
                                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(height: 40)
                                            .padding()
                                            .background(Color(AppColor.Figma.Card))
                                            .cornerRadius(12)
                                        }
                                        
                                        VStack (spacing: 5) {
                                            Text(movie.mpaRating ?? "n/a")
                                                .textCase(.uppercase)
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(height: 40)
                                        .padding()
                                        .background(Color(AppColor.Figma.Card))
                                        .cornerRadius(12)
                                        
                                        VStack (spacing: 5) {
                                            Text(movie.language ?? "n/a")
                                                .textCase(.uppercase)
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(height: 40)
                                        .padding()
                                        .background(Color(AppColor.Figma.Card))
                                        .cornerRadius(12)
                                    }
                                    .padding(.top, 16)
                                    .padding(.bottom, 16)
                                    .padding(.trailing, 16)
                                    .padding(.leading, 36)
                                }
                                .padding(-20)
                    
                        
                    
                    //Spacer()
                    
                  //  ZStack {
                        
                        //VStack {
                            
                            
                            
                          //  RemoteImage(image: movie.mediumCoverImage.safeUnwrapped)
                            
                          //  VStack (alignment: .leading){
                           //     Text(movie.title!)
                            //        .font(.largeTitle)
                            //        .fontWeight(.bold)
                            //        .foregroundColor(Color(.label))
                       //             .multilineTextAlignment(.center)
                       //     }
                                                        
                            
                
                     //   }
                        
                   // } // Close ZStack
                    
                    
                    // Place content in here for 16px padding below  carousel
                    
                    
                    HStack (spacing: 0){
                        
                            VStack {
                                HStack {
                                    Text(movie.descriptionFull!)
                                    
                                        //.frame(minWidth: 375, maxWidth: 430)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 17.5, weight: .regular, design: .rounded))
                                        .lineSpacing(7)
                                }
                                //.padding(16)
                                .padding(16)
                                
                                .background(Color(AppColor.Figma.Card))
                                .cornerRadius(12)
                                
                                
                                
                                
                            }
                            //.padding()
                            .padding(.top, 4)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            
                            
                        
                    }
                    //.padding(.vertical)
                    
                    
                    HStack (spacing: 0){
                        
                            VStack {
                                Menu("Stream Now") {
                                    if let torrents = movie.torrents {
                                        
                                        ForEach(torrents) { torrent in
                                            TorrentView(torrent: torrent, selectedHash: { hash in
                                                self.transferData(hash: hash)
                                            })
                                            .padding(.bottom)
                                        }
                                    }
                                }
                                .frame(minWidth: 375, maxWidth: 430, minHeight: 56, maxHeight: 56, alignment: .center)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color(AppColor.Figma.buttonText))
                                .contentShape(Rectangle())
                                .background(Color(AppColor.Figma.accentColor))
                                .cornerRadius(12)
                                .padding(.bottom, 16)
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            //.padding()
                            
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            
                            
                        
                    }
                 
                    
                }
            }
            .navigationBarHidden(false)
            .background(Color(AppColor.Figma.Background))
            
        }
        
        .errorAlert(error: $viewModel.error)
        //.fullScreenCover(isPresented: $showTrailerPlayer) {
        //    YoutubeFullscreenPlayerView(url: $trailerURL)
        //}
        .fullScreenCover(isPresented: $showMoviePlayer) {
            AVPlayerView(videoURL: $streamURL)
                .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $viewModel.isUploading) {
            LoaderView(movie: movie, progress: $viewModel.progress)
        }
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



extension MovieDetailsView {
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func refreshData() {
        viewModel.refreshData()
    }
    
    func transferData(hash: String) {
        viewModel.downloadMovie(hash: hash, completion: { url in
            streamURL = url
            showMoviePlayer = true
        })
    }
    
}



extension MovieDetailsView {
    private var RatingsSection: some View {
        HStack(alignment: .center) {
            RatingsBuilder(ratings: movie.rating!)
                .font(.system(size: 18))
        }
    }
    
    @ViewBuilder
    private func RatingsBuilder(ratings: Double) -> some View {
        let percent = ratings * 10
        let stars = (percent + 0.5) / 20
        let rounded = Int(stars.rounded())
        let remainder = Int(5 - rounded)
        
        HStack {
            ForEach(0 ..< rounded) { _ in
                Image(systemName: "star.fill")
                    .renderingMode(.original)
            }
            ForEach(0 ..< remainder ) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(Color(.systemGray))
            }
        }
    }
    
}

struct RemoteImage: View {
    let image: String
    var body: some View {
        AsyncImage(
            url: URL(string: image),
            content: { image in
                image.resizable()
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 260)
                    .cornerRadius(16)
                    .clipped()
            },
            placeholder: {
                Image("poster")
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .cornerRadius(16)
                    .frame(width: 165)
            }
        )
        .cornerRadius(5)
    }
}

struct BackgroundImage: View {
    let backgroundImage: String
    var body: some View {
        AsyncImage(
            url: URL(string: backgroundImage),
            content: { image in
                image.resizable()
                    .edgesIgnoringSafeArea(.all)
                                        .blur(radius: 10)
                                        .scaledToFill()
                                        .padding(-20) //Trick: To escape from white patch @top & @bottom
            },
            placeholder: {
                
            }
            
        )
        //.cornerRadius(5)
        
    }
    
}

struct LoaderView: View {
    let movie: Movies
    @Binding var progress: CGFloat
    
    var body: some View {
        VStack {
            
            VStack(alignment: .center, spacing: 20) {
                RemoteImage(image: movie.mediumCoverImage.safeUnwrapped)
                
                ProgressView(value: progress, total: 1)
                    .tint(Color(AppColor.theme))
            }
            .frame(minWidth: 160, maxWidth: 220)
            
        }
        //.background(
        //    Color(AppColor.BackGround.darkBackground)
        //)
    }
}





