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

  var body: some View {

      VStack(alignment: .leading) {

                  //URL to Torrent hash
                  //Link(("**URL:** \(torrent.url!)"), destination: URL(string: (torrent.url ?? ""))!)
                  
                  if torrent.quality != nil {
                      Text("**Quality:** \(torrent.quality!)")
                  }
                  
                  if torrent.hash != nil {
                      Text("\(torrent.hash!)")
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
              .background(Color(AppColor.BackGround.cardColour))
              .cornerRadius(10)
              .onTapGesture {
                  print("Copied to clipboard")
                  //isShowing = false
                  UIPasteboard.general.string = self.torrent.hash!
                  showToast = true
              }
      
      .toast(message: "Copied to clipboard",
             isShowing: $showToast,
             duration: Toast.short)
    }
  
}

struct Toast: ViewModifier {
  // these correspond to Android values f
  // or DURATION_SHORT and DURATION_LONG
  static let short: TimeInterval = 2
  static let long: TimeInterval = 3.5

  let message: String
  @Binding var isShowing: Bool
  let config: Config

  func body(content: Content) -> some View {
    ZStack {
      content
      toastView
    }
  }

  private var toastView: some View {
    VStack {
      Spacer()
      if isShowing {
        Group {
          Text(message)
            .multilineTextAlignment(.center)
            .foregroundColor(config.textColor)
            .font(config.font)
            .padding(8)
        }
        .background(config.backgroundColor)
        .cornerRadius(8)
        .onTapGesture {
          isShowing = false
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            isShowing = false
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 18)
    .animation(config.animation, value: isShowing)
    .transition(config.transition)
  }

  struct Config {
    let textColor: Color
    let font: Font
    let backgroundColor: Color
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation

    init(textColor: Color = .white,
         font: Font = .system(size: 14),
         backgroundColor: Color = .black.opacity(0.588),
         duration: TimeInterval = Toast.short,
         transition: AnyTransition = .opacity,
         animation: Animation = .linear(duration: 0.3)) {
      self.textColor = textColor
      self.font = font
      self.backgroundColor = backgroundColor
      self.duration = duration
      self.transition = transition
      self.animation = animation
    }
  }
}

extension View {
  func toast(message: String,
             isShowing: Binding<Bool>,
             config: Toast.Config) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: config))
  }

  func toast(message: String,
             isShowing: Binding<Bool>,
             duration: TimeInterval) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: .init(duration: duration)))
  }
}
