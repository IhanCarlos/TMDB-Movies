//
//  DSColors.swift
//  TMDB Movie
//
//  Created by ihan carlos on 30/12/25.
//

import Foundation
import UIKit

public enum Colors: String {
    
    case grayligth = "#F5F5F5"
    case gray = "#707070"
    case purple = "#8000FF"
    case pink = "#FF1F8A"
}

public extension UIColor {
    static func ds( _ color: Colors) -> UIColor {
        return UIColor(hexString: color.rawValue)
    }
}
