//
//  UIFont+Extension.swift
//  J'Ma Radio
//
//  Created by Федор Рубченков on 15.02.2023.
//

import UIKit

extension UIFont {
    
    static func mainLightFont(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "GothamPro-Light", size: size)  else { return UIFont() }
        return font
    }
        
}
