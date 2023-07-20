//
//  LoginViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseFunctions

final class LoginViewModel {
    var coordinator: LoginCoordinator?
    var presentingView: UIViewController?
    
    private let loginUseCase: LoginUseCase
    private lazy var functions = Functions.functions(region: "asia-northeast1")
    
    var email: String?
    var isEmailValid: Bool = false
    var isTermsAll: Bool = false
    var isServiceTerms: Bool = false
    var isUserTerms: Bool = false
    var isAppleLogin: Bool = false
    var isLoadingView: Bool = false
    
    var getEmailToken: PublishRelay<String> = PublishRelay()
    
    init(coordinator: LoginCoordinator,
         presentingView: UIViewController,
         loginUseCase: LoginUseCase) {
        self.coordinator = coordinator
        self.presentingView = presentingView
        self.loginUseCase = loginUseCase
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNotifi), name: .init("emailToken"), object: nil)
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let naverDidTabEvent: Observable<Void>
        let googleDidTabEvent: Observable<Void>
        let appleDidTabEvent: Observable<Void>
        let emailDidTabEvent: Observable<Void>
        let emailConfirmDidTabEvent: Observable<Void>
        let emailFieldTextEvent: ControlProperty<String?>
        let emailBackDidTabEvent: Observable<Void>
        let termsBackDidTabEvent: Observable<Void>
        let termsAllDidTabEvent: Observable<Void>
        let termsNextDidTabEvent: Observable<Void>
        let termsServiceDidTabEvent: Observable<Void>
        let termsServiceArrowDidTabEvent: Observable<Void>
        let termsUserDidTabEvent: Observable<Void>
        let termsUserArrowDidTabEvent: Observable<Void>
    }
    
    struct Output {
        var scrollViewState: PublishRelay<Bool> = PublishRelay()
        var openEmailLoginView: PublishRelay<Bool> = PublishRelay()
        var openTermsLoginView: PublishRelay<Bool> = PublishRelay()
        var emailValidation: PublishRelay<Bool> = PublishRelay()
        var msgAlert: PublishRelay<String> = PublishRelay()
        var termsAll: PublishRelay<Bool> = PublishRelay()
        var termsService: PublishRelay<Bool> = PublishRelay()
        var termsUser: PublishRelay<Bool> = PublishRelay()
        var termsURL: PublishRelay<String> = PublishRelay()
        var loadingViewState: PublishRelay<Bool> = PublishRelay()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .delaySubscription(.milliseconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (view, _) in
                view.autoLogin(output: output, disposeBag: disposeBag)
                output.scrollViewState.accept(false)
            })
            .disposed(by: disposeBag)
        
        
        input.emailDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                output.openEmailLoginView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.emailConfirmDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                if view.isEmailValid {
                    view.getEmailToken(view.email ?? "")
                    output.msgAlert.accept(I18NStrings.Login.email_Alert_Title)
                }
            })
            .disposed(by: disposeBag)
        
        input.emailFieldTextEvent
            .orEmpty
            .distinctUntilChanged()
            .map({ $0.emailValid() })
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let state = value == "" ? false : true
                output.emailValidation.accept(state)
                view.isEmailValid = state
                
                if value != "" {
                    view.email = value
                }
            })
            .disposed(by: disposeBag)
        
        input.naverDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.loginUseCase.naverLoginStart()
            })
            .disposed(by: disposeBag)
        
        input.googleDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.loginUseCase.googleLoginStart(view.presentingView!)
            })
            .disposed(by: disposeBag)
        
        input.appleDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.loginUseCase.appleLoginStart()
            })
            .disposed(by: disposeBag)
        
        input.termsAllDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.isTermsAll = !view.isTermsAll
                view.isServiceTerms = view.isTermsAll
                view.isUserTerms = view.isTermsAll
                
                output.termsAll.accept(view.isTermsAll)
                output.termsService.accept(view.isTermsAll)
                output.termsUser.accept(view.isTermsAll)
            })
            .disposed(by: disposeBag)
        
        input.termsNextDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                if view.isTermsAll {
                    let dto = ChangeIsNewUserDTO(isNewUser: "N")
                    view.changeIsNewUserAPI(dto: dto, output: output, disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(input.emailBackDidTabEvent.map { _ in return true },
                   input.termsBackDidTabEvent.map { _ in return false })
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value {
                    output.openEmailLoginView.accept(false)
                } else {
                    output.openTermsLoginView.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.termsServiceDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.isServiceTerms = !view.isServiceTerms
                output.termsService.accept(view.isServiceTerms)
                
                if view.isServiceTerms && view.isUserTerms {
                    view.isTermsAll = true
                    output.termsAll.accept(true)
                } else {
                    view.isTermsAll = false
                    output.termsAll.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.termsUserDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.isUserTerms = !view.isUserTerms
                output.termsUser.accept(view.isUserTerms)
                
                if view.isServiceTerms && view.isUserTerms {
                    view.isTermsAll = true
                    output.termsAll.accept(true)
                } else {
                    view.isTermsAll = false
                    output.termsAll.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(input.termsServiceArrowDidTabEvent.map { _ in return true },
                   input.termsUserArrowDidTabEvent.map { _ in return false })
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value {
                    // 서비스이용약관
                    output.termsURL.accept(TermsURL.service)
                } else {
                    // 개인정보처리방침
                    output.termsURL.accept(TermsURL.user)
                }
            })
            .disposed(by: disposeBag)
        
        getEmailToken
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                UserInfo.token = value
                output.msgAlert.accept("dismiss")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    view.loginAPI(output: output, disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        loginUseCase.naverInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.getSnsCustomToken(value.accessToken ?? "", output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        loginUseCase.googleInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                UserInfo.token = value
                view.loginAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        loginUseCase.appleInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                UserInfo.token = value["idToken"] as? String ?? ""
                view.isAppleLogin = true
                view.loginAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        loginUseCase.loadingState
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                output.loadingViewState.accept(value)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func getEmailToken(_ email: String) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://moneysaving.page.link/Tbeh?email=\(email)")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.handleCodeInApp = true
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return
            }
        }
    }
    
    func getSnsCustomToken(_ token: String, output: Output, disposeBag: DisposeBag) {
        functions.httpsCallable("naverCustomAuth").call(token) { [weak self] result, error in
            if let error = error {
                print("2818 \(error)")
            }

            if let res = result {
                let resdic = res.data as? [String:Any]
                let token = resdic?["firebase_token"] as? String ?? ""
                output.loadingViewState.accept(true)
                Auth.auth().signIn(withCustomToken: token) { result2 , error2 in
                    result2?.user.getIDToken(completion: { idToken, error3 in
                        UserInfo.token = idToken ?? ""
                        self?.loginAPI(output: output, disposeBag: disposeBag) // 유효하지 않은 토큰
                    })
                }
            }
        }
    }
    
    func loginAPI(output: Output, disposeBag: DisposeBag) {
        loginUseCase.emailRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                output.loadingViewState.accept(false)
                
                if model.success {
                    UserDefaults.standard.setValue("Y", forKey: UserDefaultKey.isAutoLogin)
                    UserDefaults.standard.synchronize()
                    
                    UserInfo.userName = model.data?.username ?? ""
                    if view.isAppleLogin {
                        UserInfo.appleLogin = "Y"
                    }
                    
                    if model.data?.isNewUser == "N" {
                        view.coordinator?.pushToMain()
                    } else {
                        output.openTermsLoginView.accept(true)
                    }
                    
                } else {
                    view.isAppleLogin = false
                    output.msgAlert.accept(I18NStrings.Login.email_Alert_Error_Title)
                }
                
            }, onError: { error in
                self.isAppleLogin = false
                output.loadingViewState.accept(false)
                output.msgAlert.accept(I18NStrings.error)
            })
            .disposed(by: disposeBag)
    }
    
    func customLoginAPI(output: Output, disposeBag: DisposeBag) {
        loginUseCase.customLoginRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    UserInfo.userName = model.data?.username ?? ""
                    output.openTermsLoginView.accept(true)
                } else {
                    output.msgAlert.accept(I18NStrings.Login.email_Alert_Error_Title)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func changeIsNewUserAPI(dto: ChangeIsNewUserDTO, output: Output, disposeBag: DisposeBag) {
        loginUseCase.changeIsNewUserRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    view.coordinator?.pushToMain()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func autoLogin(output: Output, disposeBag: DisposeBag) {
        if let value = UserDefaults.standard.value(forKey: UserDefaultKey.isAutoLogin) as? String, value == "Y" {
            if let user = Auth.auth().currentUser, !user.uid.isEmpty {
                user.getIDToken() { [weak self] token, error in
                    if let _ = error {
                        return
                    }
                    
                    if let token = token {
                        UserInfo.token = token
                        self?.loginAPI(output: output, disposeBag: disposeBag)
                    }
                }
            }
        }
    }
    
    @objc func getNotifi(_ notification: NSNotification) {
        let token = notification.userInfo?["emailToken"] as? String ?? ""
        UserInfo.token = token
        getEmailToken.accept(token)
    }
    
    func setUserToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: UserDefaultKey.isToken)
        UserDefaults.standard.synchronize()
    }
    
    func getUserToken() -> String {
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.isToken) as? String ?? ""
        
        return value
    }
}
