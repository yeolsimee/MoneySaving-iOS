//
//  UIApplication+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/27.
//

import UIKit

extension UIApplication {
    var statusBarHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.statusBarManager
            }
            .map {
                $0.statusBarFrame
            }
            .map(\.height)
            .max() ?? 0
    }
    
    var bottomHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.windows.first
            }
            .compactMap {
                $0.safeAreaInsets
            }
            .map(\.bottom)
            .max() ?? 0
    }
}
