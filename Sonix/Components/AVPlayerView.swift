//
//  AVPlayerView.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import Foundation
import AVKit
import SwiftUI

struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var videoURL: URL?

    private var player: AVPlayer {
        guard let videoURL = videoURL else {
            fatalError("Video player fails")
        }
        return AVPlayer(url: videoURL)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.allowsPictureInPicturePlayback = true
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
