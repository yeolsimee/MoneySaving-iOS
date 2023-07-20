//
//  UIImage+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/09.
//

import UIKit

extension UIImage {
    convenience init?(imageSet: ImageSet) {
        self.init(named: imageSet.rawValue)
    }
}
