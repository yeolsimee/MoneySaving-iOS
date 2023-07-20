//
//  MyPageButtonView.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MyPageButtonView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.instance(.pretendardSemiBold, size: 15)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var btn_Arrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .myPage_Arrow), for: .normal)
        return button
    }()
    
    private lazy var `switch`: UISwitch = {
        let `switch` = UISwitch()
        `switch`.tintColor = .white
        `switch`.onTintColor = .black
        `switch`.isHidden = true
        return `switch`
    }()
    
    lazy var btn_Title: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.titleLabel?.font = UIFont.instance(.pretendardSemiBold, size: 15)
        return button
    }()
    
    private lazy var gap: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_240)
        return view
    }()
    
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
            btn_Title.setTitle(titleText, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            btn_Title.setTitleColor(titleColor, for: .normal)
        }
    }
    
    var labelHidden: Bool = false {
        didSet {
            titleLabel.isHidden = labelHidden
        }
    }
    
    var btnTitleHidden: Bool = true {
        didSet {
            btn_Title.isHidden = btnTitleHidden
        }
    }
    
    var btnHidden: Bool = false {
        didSet {
            btn_Arrow.isHidden = btnHidden
        }
    }
    
    var switchHidden: Bool = true {
        didSet {
            `switch`.isHidden = switchHidden
        }
    }
    
    var arrowRx: Reactive<UIButton> {
        return btn_Arrow.rx
    }
    
    var toggleRx: Reactive<UISwitch> {
        return `switch`.rx
    }
    
    var buttonRx: Reactive<UIButton> {
        return btn_Title.rx
    }
    
    var toggleState: Bool = false {
        didSet {
            `switch`.isOn = toggleState
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension MyPageButtonView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        [titleLabel,
         btnStackView,
         btn_Title,
         gap].forEach {
            addSubview($0)
        }
        
        [btn_Arrow,
         `switch`].forEach {
            btnStackView.addArrangedSubview($0)
        }
        
        
    }
    
    func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.lessThanOrEqualTo(btnStackView.snp.right).offset(-10)
        }
        
        btnStackView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-24)
        }
        
        btn_Title.snp.makeConstraints { make in
            make.edges.equalTo(titleLabel.snp.edges)
        }
        
        gap.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
}
