//
//  AlertHelper.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import UIKit

class AlertHelper {
    static func showAlert(message: String,title:String?, positiveActionTitle: String = "OK", negativeActionTitle: String? = nil, negativeHandler:(()->Void)? = nil, handler:(()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: positiveActionTitle, style: .default) { (action) in
            handler? ()
        }
        
        alert.addAction(okAction)
        
        if let cancelActionTitle = negativeActionTitle {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { (action) in
                negativeHandler?()
            }
            alert.addAction(cancelAction)
        }
        DispatchQueue.main.async {
            alert.show()
        }
    }
}

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else {
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                 DispatchQueue.main.async {
                controller.present(self, animated: animated, completion: completion)
                }
            }
        }
    }
}
