//
//  CategoryButtonView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//

import SwiftUI

struct CategoryButtonView: View {
    
    let category: String
    @Binding var selectedCategory: String
    
    var body: some View {
        Text(category)
            .font(Font.system(size: 16, weight: .bold, design: .rounded))
            .padding(10)
            .frame(minWidth: 120, maxWidth: 400, minHeight: 56, maxHeight: 115)
            .background(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.SearchBar.backgroundSelected) : Color(AppColor.Figma.Card))
            .foregroundColor(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.ThemeButton.textSelected) : Color(AppColor.Components.ThemeButton.textActive))
            .cornerRadius(16)
            .padding(.top, 16)
    }
    
}



