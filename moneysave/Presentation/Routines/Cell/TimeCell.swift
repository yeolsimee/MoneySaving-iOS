//
//  TimeCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TimeCell: UICollectionViewCell {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor(colorSet: .Gray_240)?.cgColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(colorSet: .Gray_102)
        label.font = UIFont.instance(.pretendardMedium, size: 13)
        label.textAlignment = .center
        label.sizeToFit()
        return label
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
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TimeCell {
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
            make.edges.equalToSuperview().inset(11)
        }
    }
}
