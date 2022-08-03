//
//  Details.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    //@StateObject var viewModel = SearchViewModel()
    
    let title: String
    let fileType: String?
    var videoURL : URL
    var shareURL : URL!
    
    @State private var player : AVPlayer?
    //let url1 = URL(string: VideoSource)
    @State var sharingItems: [Any]?
    
    
    var body: some View {
        
            VStack {
                VStack {
                    //Text(title)
                    //Text(videoURL.absoluteString)
                    //    .textSelection(.enabled)
                    //Text(shareURL.absoluteString)
                   
                    
                    //Button(action: actionSheet) {
                     //           Image(systemName: "square.and.arrow.up")
                     //               .resizable()
                     //               .aspectRatio(contentMode: .fit)
                     //               .frame(width: 36, height: 36)
                      //      }
                    
                    
                    //Text(fileType ?? "error")
                }
                VideoPlayer(player: player)
                    .onAppear() {
                        // Start the player going, otherwise controls don't appear
                        
                        let player = AVPlayer(url: videoURL)
                        self.player = player
                        player.play()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onDisappear() {
                        // Stop the player when the view disappears
                        player?.pause()
                        
                    }
            }
            .navigationBarTitle(title, displayMode: .inline)
            .toolbar {

                
                Button(action: {
                    sharingItems = [shareURL]
                    print(title)
                    print(shareURL)
                }, label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                })
                .sheet(isPresented: .constant(sharingItems != nil)) {
                    if let sharingItems = sharingItems {
                        ShareView(sharingItems: sharingItems)
                    }
                }
                
            }
        
        
        
        
}
    struct ShareView: UIViewControllerRepresentable {
        var sharingItems: [Any]

        func makeUIViewController(context: Context) -> some UIViewController {
            return UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
 
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}




        
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
       
        
