//
//  TableViewHeaderView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/19.
//

import UIKit
import SnapKit

final class TableViewHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.instance(.pretendardExtraBold, size: 15)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(28)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
