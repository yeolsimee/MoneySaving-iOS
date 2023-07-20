//
//  EmailLoginView.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class EmailLoginView: UIView {
    private lazy var btn_Back: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .left_Arrow), for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.email_Title
        label.font = UIFont.instance(.pretendardExtraBold, size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var underView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = I18NStrings.Login.email_Place
        field.font = UIFont.instance(.pretendardRegular, size: 14)
        field.returnKeyType = .done
        field.keyboardType = .asciiCapable
        field.delegate = self
        return field
    }()
    
    private lazy var valiLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.email_Vali
        label.font = UIFont.instance(.pretendardMedium, size: 12)
        label.textColor = UIColor(colorSet: .Red_65)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private lazy var guideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_240)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var guideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Guide)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.email_Guide
        label.font = UIFont.instance(.pretendardMedium, size: 12)
        label.textColor = UIColor(colorSet: .Gray_153)
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var btn_Confirm: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.confirm, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardSemiBold, size: 16)
        button.backgroundColor = UIColor(colorSet: .Gray_153)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_153)
        return view
    }()
    
    var emailFieldRx: Reactive<UITextField> {
        return emailField.rx
    }
    
    var confirmRx: Reactive<UIButton> {
        return btn_Confirm.rx
    }
    
    var backRx: Reactive<UIButton> {
        return btn_Back.rx
    }
    
    var isEmailVelid: Bool = true {
        didSet {
            valiLabel.isHidden = isEmailVelid
            
            let backColor: UIColor = isEmailVelid ? .black : UIColor(colorSet: .Gray_153)!
            let state: UIControl.State = isEmailVelid ? .selected : .normal
            
            bottomView.backgroundColor = backColor
            btn_Confirm.isSelected = isEmailVelid
            btn_Confirm.setTitleColor(.white, for: state)
            btn_Confirm.backgroundColor = backColor
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

private extension EmailLoginView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        [btn_Back,
         scrollView,
         btn_Confirm,
         bottomView].forEach {
            self.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [titleLabel,
         underView,
         emailField,
         valiLabel,
         guideView].forEach {
            scrollContentsView.addSubview($0)
        }
        
        [guideImageView,
         guideLabel].forEach {
            guideView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        btn_Back.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(btn_Back.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(UIApplication.shared.bottomHeight)
        }
        
        btn_Confirm.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(btn_Back.snp.bottom).offset(42)
            make.left.right.equalToSuperview().inset(28)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(28)
        }
        
        underView.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(1)
        }
        
        valiLabel.snp.makeConstraints { make in
            make.top.equalTo(underView.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(28)
        }
        
        guideView.snp.makeConstraints { make in
            make.top.equalTo(valiLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().offset(-40)
        }
    
        guideImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(14)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.centerY.equalTo(guideImageView.snp.centerY)
            make.left.equalTo(guideImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-20)
        }
    }
}

extension EmailLoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        
        return true
    }
}
