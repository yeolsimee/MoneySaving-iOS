//
//  RoutineCategoryAddView.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RoutineCategoryAddView: UIView {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var gapView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.categoryAdd
        label.font = UIFont.instance(.pretendardSemiBold, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = I18NStrings.Routine.categoryPlace
        textField.font = UIFont.instance(.pretendardSemiBold, size: 14)
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var btn_Cancel: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.cancel, for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardRegular, size: 14)
        return button
    }()
    
    private lazy var btn_Save: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 14)
        return button
    }()
    
    var viewState: Bool = true {
        didSet {
            self.isHidden = viewState
        }
    }
    
    var saveRx: Reactive<UIButton> {
        return btn_Save.rx
    }
    
    var cancelRx: Reactive<UIButton> {
        return btn_Cancel.rx
    }
    
    var fieldRx: Reactive<UITextField> {
        return textField.rx
    }
    
    var fieldConponent: UITextField {
        return textField
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        backgroundColor = UIColor(colorSet: .Dim)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension RoutineCategoryAddView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        addSubview(contentsView)
        
        [titleLabel,
         textField,
         gapView,
         stackView].forEach {
            contentsView.addSubview($0)
        }
        
        [btn_Cancel,
         btn_Save].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        gapView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(gapView.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
