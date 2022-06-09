//
//  YTSModel.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct TorrentView: View {
    let torrent: Torrents
    
    var body: some View {
        VStack(alignment: .leading) {

            //URL to Torrent hash
            //Link(("**URL:** \(torrent.url!)"), destination: URL(string: (torrent.url ?? ""))!)
            
            if torrent.quality != nil {
                Text("**Quality:** \(torrent.quality!)")
            }
            
            if torrent.hash != nil {
                Text("\(torrent.hash!)")
                    .textSelection(.enabled)
            }
            
            
            
            //if torrent.type != nil {
            //    Text("**Type:** \(torrent.type!)")
            //}
            
            
            
           // if torrent.seeds != nil {
            //    Text("**Seeds:** \(torrent.seeds!)")
           // }
            
            
            //if torrent.size != nil {
            //    Text("**Size:** \(torrent.size!)")
            //}
            
            
           // if torrent.sizeBytes != nil {
           //     Text("**Size Bytes:** \(torrent.sizeBytes!)")
           // }
            
            //if torrent.dateUploaded != nil {
            //    Text("**Date Uploaded:** \(torrent.dateUploaded!)")
            //}
            
        }
        .padding()
        .background(Color(.gray))
        .cornerRadius(10)
    }
    
}

