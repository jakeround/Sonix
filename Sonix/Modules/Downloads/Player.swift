//
//  Details.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    let title: String
    let fileType: String?
    var videoURL : URL
    var shareURL : URL!
    
    @State private var player : AVPlayer?
    @State var sharingItems: [Any]?
    
    var body: some View {
        
        VStack {
            
            VideoPlayer(player: player)
                .onAppear() {
                    let player = AVPlayer(url: videoURL)
                    self.player = player
                    player.play()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onDisappear() {
                    player?.pause()
                }
        }
        .navigationBarTitle(title, displayMode: .inline)
        .toolbar {
            Button(action: {
                sharingItems = [shareURL as Any]
                print(title)
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

struct pipPlayer: UIViewControllerRepresentable {
    
    
    
    var videoUrl: URL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")!
    
    // Create the player and set the basic controls
    func makeUIViewController(context: UIViewControllerRepresentableContext<pipPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player1 = AVPlayer(url: videoUrl)
        controller.player = player1
        controller.allowsPictureInPicturePlayback = true
        controller.player!.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<pipPlayer>) {
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}




