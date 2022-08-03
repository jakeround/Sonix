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
    let title: String
    
    let youTubePlayer = YouTubePlayer(
        source: .video(id: "psL_5RIBqnY"),
        configuration: .init(
            autoPlay: true
        )
    )
    
    var body: some View {
        
        VStack {
            Text(title)
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
       // .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
       // .background(Color.white)
       // .edgesIgnoringSafeArea(.all)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
        }
       
        //.navigationViewStyle(StackNavigationViewStyle())
    }
        
