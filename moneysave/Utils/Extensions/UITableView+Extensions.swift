//
//  UITableView+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/11.
//

import UIKit
import SnapKit

extension UITableView {
    func setEmptyView(page: String?) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let emptyImageView = UIImageView()
        if let _ = page {
            emptyImageView.image = UIImage(imageSet: .myPage_Empty)
        } else {
            emptyImageView.image = UIImage(imageSet: .main_None)
        }
        emptyImageView.contentMode = .scaleAspectFit
        
        emptyView.addSubview(emptyImageView)
        
        emptyImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
        }
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
