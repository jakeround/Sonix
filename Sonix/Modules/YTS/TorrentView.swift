//
//  YTSModel.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct TorrentView: View {
    @State private var showToast = false
    let torrent: Torrents
    @State private var showingAlert = false
    
    @State private var showEditView = false
  var body: some View {

      Button(action: {
          print(torrent.hash)
          let finaltorrent = (torrent.hash)
          
     
          
          print("Copied to clipboard")
                            //isShowing = false
                            UIPasteboard.general.string = self.torrent.hash!
                            showToast = true

                  }, label: {
                      Text(torrent.quality!)
                          .padding()
                          .font(Font.largeTitle.bold())
                          .background(Color.green)
                  })
      
      
    }
  
}



