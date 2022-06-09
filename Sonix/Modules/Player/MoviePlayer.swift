//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.


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
