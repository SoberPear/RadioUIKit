//
//  UIColor+Extension.swift
//  J'Ma Radio
//
//  Created by Федор Рубченков on 15.02.2023.
//

import UIKit

infix operator |: AdditionPrecedence

extension UIColor {
    
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { $0.userInterfaceStyle == .light ? lightMode : darkMode }
    }
    
    static func j_backgroundColor() -> UIColor {
        j_white() | j_black()
    }
    
    static func j_textColor() -> UIColor {
        j_darkText() | j_white()
    }
    
    static func j_buttonBackgroundColor() -> UIColor {
        j_accent() 
    }
    
    static func j_white() -> UIColor {
        UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static func j_black() -> UIColor {
        UIColor(red: 0.016, green: 0.004, blue: 0.078, alpha: 1)
    }
    
    static func j_accent() -> UIColor {
        UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1)
    }
    
    static func j_darkText() -> UIColor {
        UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1)
    }
    
    
    
}
