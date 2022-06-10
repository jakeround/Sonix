//
//  ButtonStyle.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

   

import SwiftUI

struct ThemeButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(
                Color(AppColor.Components.ThemeButton.text)
            )
            .background(
                Color(AppColor.Components.ThemeButton.background)
                    .cornerRadius(10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(AppColor.Components.ThemeButton.border), lineWidth: 4)
            )
    }
    
}

struct HollowButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(16)
            .foregroundColor(
                Color(AppColor.Components.HollowButton.text)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(AppColor.Components.ThemeButton.border), lineWidth: 2)
            )
    }
    
}
