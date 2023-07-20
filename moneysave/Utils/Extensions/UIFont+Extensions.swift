//
//  UIFont+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/09.
//

import UIKit

extension UIFont {
    static func instance(_ name: FontNames, size: CGFloat) -> UIFont {
        let font = UIFont(name: name.rawValue, size: size)
        
        return font ?? systemFont(ofSize: size)
    }
}
