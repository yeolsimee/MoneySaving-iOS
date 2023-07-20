//
//  LoginViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: UIViewController {
    // MARK: - View Property
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isHidden = true
        return scrollView
    }()
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var naverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Green_3)
        view.layer.cornerRadius = 4
        
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Naver)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.left.equalToSuperview().offset(21)
        }
        
        let label = UILabel()
        label.text = I18NStrings.Login.naver
        label.font = UIFont.instance(.pretendardSemiBold, size: 16)
        label.textAlignment = .center
        label.textColor = .white
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var googleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(colorSet: .Gray_230)?.cgColor
        view.layer.cornerRadius = 4
        
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Google)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.left.equalToSuperview().offset(21)
        }
        
        let label = UILabel()
        label.text = I18NStrings.Login.google
        label.font = UIFont.instance(.pretendardSemiBold, size: 16)
        label.textAlignment = .center
        label.textColor = .black
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var appleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Apple)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.left.equalToSuperview().offset(21)
        }
        
        let label = UILabel()
        label.text = I18NStrings.Login.apple
        label.font = UIFont.instance(.pretendardSemiBold, size: 16)
        label.textAlignment = .center
        label.textColor = .white
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var btn_Naver: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var btn_Google: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var btn_Apple: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var btn_Email: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.Login.email, for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 14)
        return button
    }()
    
    private lazy var emailLoginView: EmailLoginView = {
        let view = EmailLoginView()
        view.isHidden = true
        return view
    }()
    
    private lazy var termsLoginView: TermsLoginView = {
        let view = TermsLoginView()
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .login_Loading)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        return view
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
}

// MARK: - Func
extension LoginViewController {
    func bind() {
        let input = LoginViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                         naverDidTabEvent: btn_Naver.rx.tap.asObservable(),
                                         googleDidTabEvent: btn_Google.rx.tap.asObservable(),
                                         appleDidTabEvent: btn_Apple.rx.tap.asObservable(),
                                         emailDidTabEvent: btn_Email.rx.tap.asObservable(),
                                         emailConfirmDidTabEvent: emailLoginView.confirmRx.tap.asObservable(),
                                         emailFieldTextEvent: emailLoginView.emailFieldRx.text,
                                         emailBackDidTabEvent: emailLoginView.backRx.tap.asObservable(),
                                         termsBackDidTabEvent: termsLoginView.backRx.tap.asObservable(),
                                         termsAllDidTabEvent: termsLoginView.termsAllRx.tap.asObservable(),
                                         termsNextDidTabEvent: termsLoginView.termsNextRx.tap.asObservable(),
                                         termsServiceDidTabEvent: termsLoginView.serviceRx.tap.asObservable(),
                                         termsServiceArrowDidTabEvent: termsLoginView.serviceArrowRx.tap.asObservable(),
                                         termsUserDidTabEvent: termsLoginView.userRx.tap.asObservable(),
                                         termsUserArrowDidTabEvent: termsLoginView.userArrowRx.tap.asObservable())
        
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.scrollViewState
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.scrollView.isHidden = value
            })
            .disposed(by: disposeBag)
        
        output.openEmailLoginView
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.showEmailLoginView(value: value)
            })
            .disposed(by: disposeBag)
        
        output.openTermsLoginView
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.openTermsView(value: value)
            })
            .disposed(by: disposeBag)
        
        output.emailValidation
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.emailLoginView.isEmailVelid = value
            })
            .disposed(by: disposeBag)
        
        output.msgAlert
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                switch value {
                case "dismiss":
                    if view.topMostViewController() is UIAlertController {
                        view.dismiss(animated: true)
                    }
                    break
                    
                case I18NStrings.Login.email_Alert_Title:
                    view.showDefaultAlert(title: value, msg: I18NStrings.Login.email_Alert)
                    break
                    
                case I18NStrings.Login.email_Alert_Error_Title:
                    view.showDefaultAlert(title: value, msg: I18NStrings.Login.error_Success)
                    break
                    
                case I18NStrings.error:
                    view.showDefaultAlert(title: value, msg: I18NStrings.Login.error_API)
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        output.termsAll
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.termsLoginView.allState = value
            })
            .disposed(by: disposeBag)
        
        output.termsService
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.termsLoginView.serviceState = value
            })
            .disposed(by: disposeBag)
        
        output.termsUser
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.termsLoginView.userState = value
            })
            .disposed(by: disposeBag)
        
        output.termsURL
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.openURL(url: value)
            })
            .disposed(by: disposeBag)
        
        output.loadingViewState
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.loadingView.isHidden = !value
            })
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        self.setupToHideKeyboardOnTapOnView()
        
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [statusView,
         scrollView,
         emailLoginView,
         termsLoginView,
         loadingView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [logoImageView,
         btnStackView,
         btn_Naver,
         btn_Google,
         btn_Apple,
         btn_Email].forEach {
            scrollContentsView.addSubview($0)
        }
        
        [naverView,
         googleView,
         appleView].forEach {
            btnStackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        btn_Email.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
        }
        
        btnStackView.snp.makeConstraints { make in
            make.bottom.equalTo(btn_Email.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(28)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(btnStackView.snp.top).offset(-50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
        }
        
        btn_Naver.snp.makeConstraints { make in
            make.edges.equalTo(naverView.snp.edges)
        }
        
        btn_Google.snp.makeConstraints { make in
            make.edges.equalTo(googleView.snp.edges)
        }
        
        btn_Apple.snp.makeConstraints { make in
            make.edges.equalTo(appleView.snp.edges)
        }
        
        emailLoginView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        termsLoginView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func showEmailLoginView(value: Bool) {
        emailLoginView.isHidden = !value
    }
    
    func openTermsView(value: Bool) {
        termsLoginView.isHidden = !value
    }
    
    func openURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
