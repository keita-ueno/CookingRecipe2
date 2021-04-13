//
//  UIColor-Extension.swift
//  CookingRecipe2
//
//  Created by Mac on 2021/04/11.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}

