//
//  Placeholder.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .padding(.horizontal, 5)
            }
            content
            .foregroundColor(Color(AppColor.Components.LoginField.activeText))
            .cornerRadius(8)
            .padding(5.0)
        }
    }
}
