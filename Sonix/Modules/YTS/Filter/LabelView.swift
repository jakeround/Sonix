//
//  LabelView.swift
//  Sonix
//
//  Created by Jake Round on 21/05/2022.
//


import SwiftUI

struct LabelView: View {
    let label: String
    let selected: Bool
    
    var body: some View {
        HStack {
            Text(label)
            
            if selected == true {
                Image(systemName: "checkmark.circle")
            }
        }
    }
}

//struct LabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        LabelView(label: "Latest", isSelected: true)
//    }
//}
