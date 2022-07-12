//
//  LabelView.swift
//  Sonix
//
//  Created by Brittany Rima on 7/9/22.
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
