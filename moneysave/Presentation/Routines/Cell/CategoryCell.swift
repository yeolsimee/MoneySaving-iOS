//
//  CategoryCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CategoryCell: UICollectionViewCell {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.instance(.pretendardBold, size: 13)
        label.textAlignment = .center
        label.textColor = UIColor(colorSet: .Gray_102)
        return label
    }()
    
    private lazy var btn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var backColor: UIColor? {
        didSet {
            contentsView.backgroundColor = backColor
        }
    }
    
    var borderColor: CGColor? {
        didSet {
            contentsView.layer.borderColor = borderColor
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var buttonRx: Reactive<UIButton> {
        return btn.rx
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryCell {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        contentView.addSubview(contentsView)
        
        [titleLabel].forEach {
            contentsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(11)
        }
    }
}
