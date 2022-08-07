//
//  YTSModel.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct TorrentView: View {
    let torrent: Torrents
    var selectedHash: ((String) -> Void)?
    
    @State private var showEditView = false
    var body: some View {
        
        Button(action: {
            let hash = torrent.hash.safeUnwrapped
            UIPasteboard.general.string = hash
            selectedHash?(hash)
        }, label: {
            Text(torrent.quality!)
                .padding()
                .font(Font.largeTitle.bold())
                .background(Color.green)
        })
    }
  
}



