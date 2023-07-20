//
//  UIColor+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/16.
//

import UIKit

extension UIColor {
    convenience init?(colorSet: ColorSet) {
        self.init(named: colorSet.rawValue)
    }
}
