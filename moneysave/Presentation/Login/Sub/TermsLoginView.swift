//
//  TermsView.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TermsLoginView: UIView {
    private lazy var btn_Back: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .left_Arrow), for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var btn_Next: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.Login.terms_Next, for: .normal)
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
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.terms_Title
        label.font = UIFont.instance(.pretendardExtraBold, size: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var termsAllView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var termsAllImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_TermsOff)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var termsAllLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.terms_All
        label.font = UIFont.instance(.pretendardBold, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var btn_TermsAll: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var underView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_240)
        return view
    }()
    
    private lazy var serviceTermsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var serviceTermsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_TermsOff)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var serviceTermsLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.terms_Service_Title
        label.font = UIFont.instance(.pretendardMedium, size: 15)
        label.textColor = UIColor(colorSet: .Gray_102)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var btn_ServiceTerms: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var btn_ServiceArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .login_TermsArrow), for: .normal)
        return button
    }()
    
    private lazy var userTermsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var userTermsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_TermsOff)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var userTermsLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Login.terms_User_Title
        label.font = UIFont.instance(.pretendardMedium, size: 15)
        label.textColor = UIColor(colorSet: .Gray_102)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var btn_UserTerms: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var btn_UserArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .login_TermsArrow), for: .normal)
        return button
    }()
    
    var termsAllRx: Reactive<UIButton> {
        return btn_TermsAll.rx
    }
    
    var termsNextRx: Reactive<UIButton> {
        return btn_Next.rx
    }
    
    var backRx: Reactive<UIButton> {
        return btn_Back.rx
    }
    
    var serviceRx: Reactive<UIButton> {
        return btn_ServiceTerms.rx
    }
    
    var serviceArrowRx: Reactive<UIButton> {
        return btn_ServiceArrow.rx
    }
    
    var userRx: Reactive<UIButton> {
        return btn_UserTerms.rx
    }
    
    var userArrowRx: Reactive<UIButton> {
        return btn_UserArrow.rx
    }
    
    var allState: Bool = false {
        didSet {
            let image = allState ? UIImage(imageSet: .login_TermsOn) : UIImage(imageSet: .login_TermsOff)
            let backColor: UIColor = allState ? .black : UIColor(colorSet: .Gray_153)!
            let state: UIControl.State = allState ? .selected : .normal
            
            termsAllImageView.image = image
            bottomView.backgroundColor = backColor
            btn_Next.backgroundColor = backColor
            btn_Next.isSelected = allState
            btn_Next.setTitleColor(.white, for: state)
        }
    }
    
    var serviceState: Bool = false {
        didSet {
            let image = serviceState ? UIImage(imageSet: .login_TermsOn) : UIImage(imageSet: .login_TermsOff)
            let textColor: UIColor = serviceState ? UIColor(colorSet: .Black_51)! : UIColor(colorSet: .Gray_102)!
            
            serviceTermsImageView.image = image
            serviceTermsLabel.textColor = textColor
        }
    }
    
    var userState: Bool = false {
        didSet {
            let image = userState ? UIImage(imageSet: .login_TermsOn) : UIImage(imageSet: .login_TermsOff)
            let textColor: UIColor = userState ? UIColor(colorSet: .Black_51)! : UIColor(colorSet: .Gray_102)!
            
            userTermsImageView.image = image
            userTermsLabel.textColor = textColor
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

private extension TermsLoginView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        [btn_Back,
         scrollView,
         btn_Next,
         bottomView].forEach {
            self.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [titleLabel,
         termsAllView,
         underView,
         serviceTermsView,
         userTermsView].forEach {
            scrollContentsView.addSubview($0)
        }
        
        [termsAllLabel,
         termsAllImageView,
         btn_TermsAll].forEach {
            termsAllView.addSubview($0)
        }
        
        [serviceTermsLabel,
         serviceTermsImageView,
         btn_ServiceTerms,
         btn_ServiceArrow].forEach {
            serviceTermsView.addSubview($0)
        }
        
        [userTermsLabel,
         userTermsImageView,
         btn_UserTerms,
         btn_UserArrow].forEach {
            userTermsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        btn_Back.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(UIApplication.shared.bottomHeight)
        }
        
        btn_Next.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(btn_Back.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btn_Next.snp.top)
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(28)
            make.right.equalToSuperview()
        }
        
        termsAllView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(28)
            make.right.lessThanOrEqualToSuperview().offset(-28)
        }
        
        termsAllLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
        
        termsAllImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(termsAllLabel.snp.left).offset(-8)
            make.centerY.equalTo(termsAllLabel.snp.centerY)
        }
        
        btn_TermsAll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        underView.snp.makeConstraints { make in
            make.top.equalTo(termsAllView.snp.bottom).offset(17)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(1)
        }
        
        serviceTermsView.snp.makeConstraints { make in
            make.top.equalTo(underView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(28)
        }
        
        serviceTermsLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(btn_ServiceArrow.snp.left).offset(-10)
        }
        
        serviceTermsImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(serviceTermsLabel.snp.left).offset(-8)
            make.centerY.equalTo(serviceTermsLabel.snp.centerY)
        }
        
        btn_ServiceTerms.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(serviceTermsImageView.snp.left)
            make.right.equalTo(serviceTermsLabel.snp.right)
        }
        
        btn_ServiceArrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(serviceTermsLabel.snp.centerY)
        }
        
        userTermsView.snp.makeConstraints { make in
            make.top.equalTo(serviceTermsView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        userTermsLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(btn_UserArrow.snp.left).offset(-10)
        }
        
        userTermsImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(userTermsLabel.snp.left).offset(-8)
            make.centerY.equalTo(userTermsLabel.snp.centerY)
        }
        
        btn_UserTerms.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(userTermsView.snp.left)
            make.right.equalTo(userTermsLabel.snp.right)
        }
        
        btn_UserArrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(userTermsLabel.snp.centerY)
        }
    }
}
