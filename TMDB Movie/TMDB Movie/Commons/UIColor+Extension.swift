//
//  UIColor+Extension.swift
//  Rebanho
//
//  Created by ihan carlos on 03/04/24.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask
        let redProportion   = CGFloat(red) / 255.0
        let greenProportion = CGFloat(green) / 255.0
        let blueProportion  = CGFloat(blue) / 255.0
        self.init(red: redProportion, green: greenProportion, blue: blueProportion, alpha: alpha)
    }
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alph: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alph)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}
