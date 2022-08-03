//
//  YTSDetails.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI

import WebKit

struct MovieDetailsView: View {
    
    let movie: Movies
    @StateObject var viewModel = TransferViewModel()
    //let youTubePlayer: YouTubePlayer = \(movie.trailer?)
    @State private var isShowingWebView: Bool = false
    
    @State private var array = [1, 1, 2]
    
    func doSomething(index: Int) {
        self.array = [1, 2, 3]
    }
    
    @State private var oneActive: Bool = false
    @State private var twoActive: Bool = false
    
    @State private var showingSheet = false
    @Environment(\.horizontalSizeClass) var sizeClass
    
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                ZStack {
                    
                    AsyncImage(
                        url: URL(string: movie.mediumCoverImage!),
                        content: { image in
                            image.resizable()
                                .resizable()
                                .scaledToFill()
                                .frame(height: 500)
                                .frame(minWidth: UIScreen.screenWidth, maxWidth: .infinity)
                                .clipped()
                                .blur(radius: 80)
                                .opacity(0.1)
                                .transition(.opacity.animation(.easeIn))
                        },
                        placeholder: {
                            Image("poster")
                                .aspectRatio(contentMode: .fit)
                            //.resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .frame(width: 165)
                        }
                        
                    ).frame(height: 500)
                    
                    VStack {
                        AsyncImage(
                            url: URL(string: movie.mediumCoverImage!),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                //.resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    .frame(width: 180)
                            },
                            placeholder: {
                                Image("poster")
                                    .aspectRatio(contentMode: .fit)
                                //.resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    .frame(width: 180)
                            }
                        )
                        
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
                            
                            NavigationLink(destination: YouTubeTrailer(trailer: movie.ytTrailerCode!, title: movie.title!)) {
                                Text("Trailer")
                            }
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(minWidth: 100, maxWidth: 390, minHeight: 54)
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                            .background(Color.primary)
                            .cornerRadius(13)
                            
                            
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
                                Text(movie.descriptionFull!)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        
                        
                        
                    } else {
                        HStack (spacing: 32) {
                            HStack {
                                Text(movie.descriptionFull!)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .tracking(0.2)
                                    .lineSpacing(2)

                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Spacer()
                            }
                            
                            
                            VStack (alignment: .leading){
                                Menu("Play") {
                                    if movie.torrents != nil {
                                        
                                        ForEach(movie.torrents!) { torrent in
                                            TorrentView(torrent: torrent)
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
                                .frame(minWidth: 100, maxWidth: 254, minHeight: 48)
                                .foregroundColor(.white)
                                .contentShape(Rectangle())
                                .background(Material.ultraThick)
                                .cornerRadius(10)
                                Spacer()
                            }
                            
                        }
                        .padding(.left)
                        .padding(.right)
                    }
                }
                .padding(.vertical)
                
                
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
                    .padding()
                
            }
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
    
    func transferData() {
        viewModel.trasferData()
    }
    
    
}



extension MovieDetailsView {
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

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
