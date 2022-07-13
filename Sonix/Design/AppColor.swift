//
//  AppColor.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import Foundation

import UIKit
import SwiftUI

struct AppColor {
    
    enum BackGround {
        @Theme(light: UIColor(hex: "F2F1F6"),
               dark: UIColor(hex: "1C1C1E"))
        static var cardColour: UIColor
        
        @Theme(light: UIColor(hex: "ffffff"),
               dark: UIColor(hex: "333333"))
        static var lightBackground: UIColor
        
        @Theme(light: UIColor(hex: "ffffff"),
               dark: UIColor(hex: "000000"))
        static var darkBackground: UIColor
        
        @Theme(light: UIColor(hex: "ffffff"),
               dark: UIColor(hex: "161616F0"))
        static var navigationBarBackground: UIColor
        
        @Theme(light: UIColor(hex: "ffffff"),
               dark: UIColor(hex: "161616F0"))
        static var tabBarBackground: UIColor
    }
    
    enum Title {
        @Theme(light: UIColor(hex: "000000"),
               dark: UIColor(hex: "ffffff"))
        static var defaultType: UIColor
        
        @Theme(light: UIColor(hex: "aaaaaa"),
               dark: UIColor(hex: "aaaaaa"))
        static var subType: UIColor

    }
    
    enum Components {
        
        enum ThemeButton {
            
            @Theme(light: UIColor(hex: "F2F1F6"),
                   dark: UIColor(hex: "181818"))
            static var background: UIColor
            
            @Theme(light: UIColor(hex: "181818"),
                   dark: UIColor(hex: "222222"))
            static var filter: UIColor
            
            @Theme(light: UIColor(hex: "FFFFFF"),
                   dark: UIColor(hex: "FFFFFF"))
            static var text: UIColor
            
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "FE3A5C"))
            static var border: UIColor
            
            @Theme(light: UIColor(hex: "000000"),
                   dark: UIColor(hex: "ffffff"))
            static var textActive: UIColor
            
            @Theme(light: UIColor(hex: "ffffff"),
                   dark: UIColor(hex: "000000"))
            static var textSelected: UIColor
        }
        
        enum HollowButton {
            
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "FE3A5C"))
            static var text: UIColor
            
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "FE3A5C"))
            static var border: UIColor
            
        }
        
        enum LoginField {
            
            @Theme(light: UIColor(hex: "000000"),
                   dark: UIColor(hex: "AAAAAA"))
            static var background: UIColor
            
            @Theme(light: UIColor(hex: "000000"),
                   dark: UIColor(hex: "AAAAAA"))
            static var text: UIColor
            
            @Theme(light: UIColor(hex: "000000"),
                   dark: UIColor(hex: "ffffff"))
            static var activeText: UIColor
                        
        }
        
        enum SearchBar {
            
            @Theme(light: UIColor(hex: "F2F1F6"),
                   dark: UIColor(hex: "F2F1F6"))
            static var background: UIColor
            
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "ffffff"))
            static var backgroundSelected: UIColor
            
            @Theme(light: UIColor(hex: "38383A"),
                   dark: UIColor(hex: "ffffff"))
            static var text: UIColor
            
        }
        
        enum TabBar {
            // Global Colour
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "FE3A5C"))
            static var tint: UIColor
            
        }
        
        enum FileList {
            
            @Theme(light: UIColor(hex: "1C1C1E"),
                   dark: UIColor(hex: "1C1C1E"))
            static var background: UIColor
            
            @Theme(light: UIColor(hex: "FFFFFF"),
                   dark: UIColor(hex: "FFFFFF"))
            static var text: UIColor
            
        }
        
        enum SettingList {
            
            @Theme(light: UIColor(hex: "1C1C1E"),
                   dark: UIColor(hex: "1C1C1E"))
            static var background: UIColor
            
            @Theme(light: UIColor(hex: "FE3A5C"),
                   dark: UIColor(hex: "FE3A5C"))
            static var text: UIColor
            
        }
        
    }

    @Theme(light: UIColor(hex: "000000"),
           dark: UIColor(hex: "FFFFFF"))
    static var primaryText: UIColor

    @Theme(light: UIColor(hex: "EEEFF2"),
           dark: UIColor.safeSeperator)
    static var seperator: UIColor
    
    @Theme(light: UIColor(hex: "FE3A5C"),
           dark: UIColor(hex: "FE3A5C"))
    static var theme: UIColor
    
    
}

// MARK: - BackPort iOS 13 and older Colors
extension UIColor {
    static var safeSystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .black
        }
    }

    static var safeLabel: UIColor {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .white
        }
    }

    static var safeSeperator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        } else {
            return UIColor.gray.withAlphaComponent(0.6)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
