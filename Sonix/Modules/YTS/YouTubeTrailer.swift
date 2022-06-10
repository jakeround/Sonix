//
//  YouTubeTrailer.swift
//  Sonix
//
//  Created by Jake Round on 08/06/2022.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubeTrailer: View {
    
    let trailer: String

    let youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=psL_5RIBqnY"

    var body: some View {
        Text(trailer)
        YouTubePlayerView(self.youTubePlayer) { state in
            // Overlay ViewBuilder closure to place an overlay View
            // for the current `YouTubePlayer.State`
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
    }

}

