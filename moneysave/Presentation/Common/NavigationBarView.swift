//
//  NavigationBarView.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NavigationBarView: UIView {
    private lazy var btn_Back: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(imageSet: .left_Arrow)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.instance(.pretendardBold, size: 18)
        return label
    }()
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var buttonRx: Reactive<UIButton> {
        return btn_Back.rx
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension NavigationBarView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        addSubview(btn_Back)
        addSubview(titleLabel)
    }
    
    func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.centerX.equalToSuperview()
        }
        
        btn_Back.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}
