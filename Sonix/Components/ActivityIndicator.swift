//
//  ActivityIndicator.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import SwiftUI
import UIKit

struct DefaultActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<DefaultActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = AppColor.theme
        activityIndicator.tintColor = AppColor.theme
        activityIndicator.startAnimating()
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<DefaultActivityIndicator>) {}
}


struct ActivityIndicator: View {
    
    var body: some View {
        DefaultActivityIndicator()
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}

