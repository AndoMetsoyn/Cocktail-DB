//
//  UIColor+AppColors.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import UIKit

extension UIColor {
    
    enum appColor: String {
        case paleGrey
        case textGrey
        
        func color() -> UIColor {
            return UIColor(named: self.rawValue)!
        }
    }
}

