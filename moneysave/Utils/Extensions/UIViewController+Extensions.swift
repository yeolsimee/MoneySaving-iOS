//
//  UIViewController+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit

extension UIViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showDefaultAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: I18NStrings.confirm, style: .default)
        
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        return self.presentedViewController!.topMostViewController()
    }
}
