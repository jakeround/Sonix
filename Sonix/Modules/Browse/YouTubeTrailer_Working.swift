//
//  YouTubeTrailer_Working.swift
//  Sonix
//
//  Created by Jake Round on 03/08/2022.
//

import SwiftUI
import SwiftUIYouTubePlayer

struct YouTubeTrailer_Working: View {
    @State private var action = YouTubePlayerAction.play
    @State private var state = YouTubePlayerState.empty
    
    let trailer: String
    let title: String
    
    var body: some View {
        VStack {
            YouTubePlayer(action: $action, state: $state)
            
            .onAppear() {
                action = .loadID(trailer)
            }
        }
        
        .navigationTitle(title)
        
    }
}
