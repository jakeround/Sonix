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
            .font(.headline.bold())
            .padding()
            .background(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.SearchBar.backgroundSelected) : Color(AppColor.Components.ThemeButton.background))
            .foregroundColor(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.ThemeButton.textSelected) : Color(AppColor.Components.ThemeButton.textActive))
            .clipShape(Capsule())
    }
}
