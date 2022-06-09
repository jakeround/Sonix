//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.

import UIKit

@propertyWrapper
struct Theme {
    let light: UIColor
    let dark: UIColor

    var wrappedValue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return self.dark
                } else {
                    return self.light
                }
            }
        } else {
            return ThemeManager.isDarkModeEnabled ? self.dark : self.light
        }
    }
}

enum ThemeManager {
    static var isDarkModeEnabled = false
}


