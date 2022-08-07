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
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 0) {
                    ZStack {
                        
                        VStack {
                            
                            RemoteImage(image: movie.mediumCoverImage.safeUnwrapped)
                            
                            VStack (alignment: .leading){
                                Text(movie.title!)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.center)
                            }
                                                        
                            
                            GeometryReader { geometry in
                                ScrollView(.horizontal) {
                                    HStack {
                                        Spacer()
                                        if movie.yearText != nil {
                                            VStack (spacing: 5) {
                                                let year = String(movie.yearText!).replacingOccurrences(of: ",", with: "")
                                                Text(year)
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            .frame(height: 50)
                                            .padding(.left)
                                            .padding(.right)
                                            .background(Color(AppColor.BackGround.cardColour))
                                            .cornerRadius(50)
                                        }
                                        
                                        VStack (spacing: 5) {
                                            Text(movie.duration)
                                                .font(.system(size: 16, weight: .bold, design: .default))
                                        }
                                        .frame(height: 50)
                                        .padding(.left)
                                        .padding(.right)
                                        .background(Color(AppColor.BackGround.cardColour))
                                        .cornerRadius(50)
                                        
                                        VStack (spacing: 5) {
                                            Text(movie.language ?? "n/a")
                                                .textCase(.uppercase)
                                                .font(.system(size: 16, weight: .bold, design: .default))
                                        }
                                        .frame(height: 50)
                                        .padding(.left)
                                        .padding(.right)
                                        .background(Color(AppColor.BackGround.cardColour))
                                        .cornerRadius(50)
                                        
                                        VStack (spacing: 5) {
                                            Text(movie.mpaRating ?? "n/a")
                                                .textCase(.uppercase)
                                                .font(.system(size: 16, weight: .bold, design: .default))
                                        }
                                        .frame(height: 50)
                                        .padding(.left)
                                        .padding(.right)
                                        .background(Color(AppColor.BackGround.cardColour))
                                        .cornerRadius(50)
                                        
                                        if movie.rating != nil {
                                            VStack (spacing: 5) {
                                                let imdbRating = String(movie.rating!).replacingOccurrences(of: ",", with: "")
                                                Text("\(imdbRating) / 10")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                                //RatingsSection
                                            }
                                            .frame(height: 50)
                                            .padding(.left)
                                            .padding(.right)
                                            .background(Color(AppColor.BackGround.cardColour))
                                            .cornerRadius(50)
                                        }
                                        Spacer()
                                    }
                                    //.padding()
                                    .frame(width: geometry.size.width)
                                    .frame(height: 50)
                                }
                            }.frame(height: 50)
                        }
                        
                    } // Close ZStack
                    
                    
                    
                    
                    
                    HStack {
                        if sizeClass == .compact {
                            VStack {
                                                            
                                Button {
                                    trailerURL = movie.ytTrailerCode.safeUnwrapped
                                    showTrailerPlayer.toggle()
                                } label: {
                                    Text("Trailer")
                                }
                                .buttonStyle(ThemeButtonStyle())
                                
                                Menu("Select Quality") {
                                    if let torrents = movie.torrents {
                                        
                                        ForEach(torrents) { torrent in
                                            TorrentView(torrent: torrent, selectedHash: { hash in
                                                self.transferData(hash: hash)
                                            })
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
                                
                                NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)) {
                                                                    Text("Trailer")
                                                                }
                                                                
                                                                .font(.system(size: 18, weight: .bold, design: .default))
                                                                .frame(minWidth: 100, maxWidth: 254, minHeight: 48)
                                                                .foregroundColor(.white)
                                                                .contentShape(Rectangle())
                                                                .background(Material.ultraThick)
                                                                .cornerRadius(10)
                                                                Spacer()
                                HStack {
                                    Text(movie.descriptionFull!)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding()
                            
                            
                            
                            
                        } else {
                            HStack (spacing: 32) {
                                HStack {
                                    Text(movie.descriptionFull!)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .tracking(0.2)
                                        .lineSpacing(2)
                                    
                                        .multilineTextAlignment(.leading)
                                        .frame(minWidth: 100, maxWidth: .infinity)
                                    Spacer()
                                }
                                .frame(minWidth: 100, maxWidth: .infinity)
                                
                                
                                VStack (alignment: .leading){
                                    Menu("Play") {
                                        if let torrents = movie.torrents {
                                            ForEach(torrents) { torrent in
                                                TorrentView(torrent: torrent, selectedHash: { hash in
                                                    self.transferData(hash: hash)
                                                })
                                                .padding(.bottom)
                                            }
                                        }
                                    }
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .frame(minWidth: 100, maxWidth: 254, minHeight: 48)
                                    .foregroundColor(.white)
                                    .contentShape(Rectangle())
                                    .background(Color.primary)
                                    .cornerRadius(10)
                                    
                                    
                                    NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)) {
                                                                    Text("Trailer")
                                                                }
                                                                .font(.system(size: 18, weight: .bold, design: .default))
                                                                .frame(minWidth: 100, maxWidth: 254, minHeight: 54)
                                                                .foregroundColor(.white)
                                                                .contentShape(Rectangle())
                                                                .background(Color.primary)
                                                                .cornerRadius(13)
                                                                
                                    Spacer()
                                }
                                
                            }
                            .padding(.left)
                            .padding(.right)
                        }
                    }
                    .padding(.vertical)
                    
                    
                }
            }
            
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



extension View {
    func printUI(_ args: Any..., separator: String = " ", terminator: String = "\n") -> EmptyView {
        let output = args.map(String.init(describing:)).joined(separator: separator)
        print(output, terminator: terminator)
        return EmptyView()
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
