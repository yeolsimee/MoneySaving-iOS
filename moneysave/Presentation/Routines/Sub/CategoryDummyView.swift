//
//  CategoryDummyView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/21.
//

import UIKit
import SnapKit

final class CategoryDummyView: UIView {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .black
        label.font = UIFont.instance(.pretendardBold, size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryDummyView {
    func configure(){
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [contentsView,
         label].forEach {
            addSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(11)
        }
    }
}
