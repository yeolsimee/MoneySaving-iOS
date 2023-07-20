//
//  MyPageCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toast_Swift

protocol MyPageCellProtocol {
    func categoryViewState(state: Bool)
    func logOut()
    func withDraw()
    func openTerms(url: String)
    func openSetting()
}

final class MyPageCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var categoryView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.category
        return view
    }()
    
    private lazy var pushView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.push
        view.btnHidden = true
        view.switchHidden = false
        return view
    }()
    
    private lazy var gapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_240)
        return view
    }()
    
    private lazy var termsView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.terms
        return view
    }()
    
    private lazy var individualView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.individual
        return view
    }()
    
    private lazy var helpView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.help
        return view
    }()
    
    private lazy var gapView_2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: .Gray_240)
        return view
    }()
    
    private lazy var logoutView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.logout
        view.titleColor = .black
        view.labelHidden = true
        view.btnTitleHidden = false
        view.btnHidden = true
        return view
    }()
    
    private lazy var leaveView: MyPageButtonView = {
        let view = MyPageButtonView()
        view.titleText = I18NStrings.MyPage.leave
        view.titleColor = .red
        view.labelHidden = true
        view.btnTitleHidden = false
        view.btnHidden = true
        return view
    }()
    
    var toggleState: Bool = false {
        didSet {
            pushView.toggleState = toggleState
        }
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var delegate: MyPageCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        categoryView.arrowRx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.delegate?.categoryViewState(state: true)
            })
            .disposed(by: disposeBag)
        
        pushView.toggleRx
            .controlEvent(.valueChanged)
            .withLatestFrom(pushView.toggleRx.value)
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                print("UserInfo : \(UserInfo.systemPushState)")
                if value {
                    
                    if !view.getSettingPushState() {
                        
                        if !UserInfo.systemPushState {
                            view.delegate?.openSetting()
                            view.pushView.toggleState = false
                        } else {
                            view.pushView.toggleState = true
                            
                            UserDefaults.standard.setValue(true, forKey: UserDefaultKey.isSettingPushState)
                            UserDefaults.standard.synchronize()
                            
                            view.makeToast(I18NStrings.MyPage.pushOn)
                        }
                        
                    } else {
                        UserDefaults.standard.setValue(false, forKey: UserDefaultKey.isSettingPushState)
                        UserDefaults.standard.synchronize()
                        
                        view.makeToast(I18NStrings.MyPage.pushOff)
                    }
                                        
                } else {
                    UserDefaults.standard.setValue(false, forKey: UserDefaultKey.isSettingPushState)
                    UserDefaults.standard.synchronize()
                    
                    view.makeToast(I18NStrings.MyPage.pushOff)
                }
            })
            .disposed(by: disposeBag)
            
        Observable.merge(
            termsView.arrowRx.tap.map { _ in "terms" },
            individualView.arrowRx.tap.map { _ in "individual" }
        )
        .withUnretained(self)
        .subscribe(onNext: { (view, value) in
            switch value {
            case "terms":
                view.delegate?.openTerms(url: TermsURL.service)
                break
            case "individual":
                view.delegate?.openTerms(url: TermsURL.user)
                break
            
            default:
                break
            }
        })
        .disposed(by: disposeBag)
        
        logoutView.buttonRx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.delegate?.logOut()
            })
            .disposed(by: disposeBag)
        
        leaveView.buttonRx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.delegate?.withDraw()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MyPageCell Not implemented required init?(coder: NSCoder)")
    }
}

private extension MyPageCell {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [imageView,
         scrollView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [categoryView,
         pushView,
         gapView,
         termsView,
         individualView,
         gapView_2,
         logoutView,
         leaveView].forEach {
            scrollContentsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.right.equalToSuperview()
        }
        
        pushView.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.top.equalTo(pushView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1.5)
        }
        
        termsView.snp.makeConstraints { make in
            make.top.equalTo(gapView.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        individualView.snp.makeConstraints { make in
            make.top.equalTo(termsView.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        gapView_2.snp.makeConstraints { make in
            make.top.equalTo(individualView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1.5)
        }
        
        logoutView.snp.makeConstraints { make in
            make.top.equalTo(gapView_2.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        leaveView.snp.makeConstraints { make in
            make.top.equalTo(logoutView.snp.bottom).offset(13)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func getSettingPushState() -> Bool {
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.isSettingPushState) as? Bool ?? false
        
        return value
    }
}

// MARK: - Protocol
//extension MyPageCell: CategoryListViewProtocol {
//    func deleteCategory(id: String) {
////        delegate?.categoryDelete(id: id)
//    }
//}
