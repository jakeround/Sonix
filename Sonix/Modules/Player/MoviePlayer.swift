//
//  MoviePlayer.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//


import SwiftUI
import AVKit

struct MoviePlayer: View {
    
    let player: AVPlayer!
    
    init(url: String) {
        player = AVPlayer(url:  URL(string: url)!)
    }
    
    var body: some View {
        
        VideoPlayer(player: player) {
            VStack {
                
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(AppColor.BackGround.darkBackground))
        
    }
}

extension MoviePlayer {
    struct Constants {
    }
}

struct MoviePlayer_Previews: PreviewProvider {
    static var previews: some View {
        MoviePlayer(url: "https://bit.ly/swswift")
    }
}
