//
//  YouTubeTrailer.swift
//  Sonix
//
//  Created by Jake Round on 08/06/2022.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubeTrailer_New: View {
    
    let trailer: String // Output sutgWjz10sM
    let title: String
    
    let youTubePlayer: YouTubePlayer = YouTubePlayer(source: .video(id: "NOOSpRRAEAc"), configuration: .init(
        isUserInteractionEnabled: true,
        allowsPictureInPictureMediaPlayback: true,
        autoPlay: true,
        captionLanguage: nil,
        showCaptions: false,
        progressBarColor: .red,
        showControls: false,
        keyboardControlsDisabled: false,
        enableJavaScriptAPI: true,
        endTime: nil,
        showFullscreenButton: false,
        language: nil,
        showAnnotations: false,
        loopEnabled: false,
        useModestBranding: true,
        playInline: false,
        showRelatedVideos: false,
        startTime: nil,
        referrer: nil))
    
    var body: some View {
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
        }
   
}
