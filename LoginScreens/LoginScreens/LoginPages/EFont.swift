//
//  EFont.swift
//  LoginScreens
//
//  Created by Charisma Infotainment on 14/05/24.
//

import SwiftUI

enum  EFont: String {
    case thin = "InterVariable-Thin"
    case regular = "InterVariable"
    case extraLight = "InterVariable-ExtraLight"
    case light = "InterVariable-Light"
    case medium = "InterVariable-Medium"
    case semiBold = "InterVariable-SemiBold"
    case bold = "InterVariable-Bold"
    case extraBold = "InterVariable-ExtraBold"
    case black = "InterVariable-Black"
}

extension Font {
    static func applyFont(_ font: EFont, size: CGFloat) -> Font {
        return Font.custom(font.rawValue, size: size)
    }
}
