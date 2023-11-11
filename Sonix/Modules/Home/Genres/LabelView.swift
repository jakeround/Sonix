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
        //.padding(16)
        .frame(minWidth: 90, maxWidth: 90, minHeight: 75, maxHeight: 75, alignment: .center)
           // .border(Color(AppColor.Figma.Card), width: 4)
            //.background(Color(AppColor.Figma.Card))
           // .foregroundColor(Color(AppColor.Figma.TitleText))
           // .font(.system(size: 18, weight: .bold, design: .rounded))
            //.cornerRadius(16)
           // .border(Color(AppColor.Figma.Card), width: 4)
           // .padding(4)
          // .cornerRadius(16)
            //.padding(16)
        .multilineTextAlignment(.center)
        .font(.system(size: 15, weight: .semibold, design: .rounded))
        .foregroundColor(Color(AppColor.Figma.TitleText))
        .border(Color(AppColor.Figma.buttonBorder), width: 1, cornerRadius: 12)
        
        
        
        
        
    }
    
}

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

//struct LabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        LabelView(label: "Latest", isSelected: true)
//    }
//}
