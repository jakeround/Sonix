//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

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
            .foregroundColor(Color.white)
            .padding(5.0)
        }
    }
}
