//
//  YouTubeTrailer.swift
//  Sonix
//
//  Created by Jake Round on 08/06/2022.
//

import SwiftUI
import SwiftUIYouTubePlayer

struct YouTubeTrailer: View {
    
    let trailer: String
    let title: String
    
    @State private var action = YouTubePlayerAction.play
    @State private var state = YouTubePlayerState.empty
    
    
    private var buttonText: String {
        switch state.status {
        case .playing:
            return "Pause"
        case .unstarted,  .ended, .paused:
            return "Play"
        case .buffering, .queued:
            return "Wait"
        }
    }
    private var infoText: String {
        "Q: \(state.quality)"
    }
    
    var body: some View {
        
        VStack {
            YouTubePlayer(action: $action, state: $state)
            .onAppear {
                action = .loadID(trailer)
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
        

