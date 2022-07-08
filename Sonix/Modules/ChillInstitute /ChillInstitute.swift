//
//  ChillInstitute.swift
//  Sonix
//
//  Created by Jake Round on 25/04/2022.
//

import SwiftUI
import WebKit
 
struct ChillInstitute: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct ChillInstitute_Previews: PreviewProvider {
    static var previews: some View {
        ChillInstitute(url: URL(string: "https://chill.institute/")!)
    }
}
