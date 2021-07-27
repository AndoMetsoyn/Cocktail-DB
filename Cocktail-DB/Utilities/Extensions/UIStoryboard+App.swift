//
//  UIStoryboard+App.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import Foundation

import UIKit

extension UIStoryboard {
    enum App: String {
        case Drinks
        
        var storyboard: UIStoryboard {
            return UIStoryboard(name: self.rawValue, bundle: nil)
        }
    }
}

// MARK: - Instantiate ViewController -

extension UIStoryboard {
    func instantiateViewController<T>(_ viewControllerType: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
