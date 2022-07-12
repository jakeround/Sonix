//
//  CategoryButtonView.swift
//  Sonix
//
//  Created by Brittany Rima on 7/8/22.
//

import SwiftUI

struct CategoryButtonView: View {
    let category: String
    @Binding var selectedCategory: String
    

    
    
    var body: some View {
        Text(category)
            .font(.headline.bold())
        .padding()
        .background(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.SearchBar.background) : Color(AppColor.Components.ThemeButton.background))
        .foregroundColor(selectedCategory.contains(category.dropFirst(2)) ? Color(AppColor.Components.ThemeButton.background) : .white)
        .clipShape(Capsule())

        
      
        

    }
}
//
//struct CategoryButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryButtonView(category: "Comedy", selectedCategory:)
//    }
//}
