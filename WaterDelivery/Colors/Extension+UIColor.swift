//
//  Extension+UIColor.swift
//  WaterDelivery
//
//  Created by Emil on 05.04.23.
//

import UIKit

struct AppColors {
    static let background = UIColor(hex: "#FFFFFF")
    static let primary = UIColor(hex: "#00BAE3")
    static let secondary = UIColor(hex: "#B6EFFB")
    static let inputs = UIColor(hex: "#878787")
    static let error = UIColor(hex: "#FF5B54")
}

extension UIColor {
    convenience init(hex: String) {
        var hexWithoutPrefix = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexWithoutPrefix.hasPrefix("#") {
            hexWithoutPrefix.remove(at: hexWithoutPrefix.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexWithoutPrefix).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
