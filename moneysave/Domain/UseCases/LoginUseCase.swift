//
//  IntroUseCase.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginUseCaseProtocol {
    func googleLoginStart(_ presenting: UIViewController)
    func kakaoLoginStart()
    func naverLoginStart()
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let emailRepository: LoginRepositoryProtocol
    private let googleService: GoogleServiceProtocol
    private let kakaoService: KakaoServiceProtocol
    private let naverService: NaverServiceProtocol
    private let appleService: AppleServiceProtocol
    private let changeIsNewUserRepository: ChangeIsNewUserProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var loadingState: PublishRelay<Bool> = PublishRelay()
    var googleInfo: PublishRelay<String> = PublishRelay()
    var kakaoInfo: PublishRelay<KakaoUserInfo> = PublishRelay()
    var naverInfo: PublishRelay<NaverUserInfo> = PublishRelay()
    var appleInfo: PublishRelay<[String:Any]> = PublishRelay()
    
    init(emailRepository: LoginRepositoryProtocol,
         googleService: GoogleServiceProtocol,
         kakaoService: KakaoServiceProtocol,
         naverService: NaverServiceProtocol,
         appleService: AppleServiceProtocol,
         changeIsNewUserRepository: ChangeIsNewUserProtocol) {
        self.emailRepository = emailRepository
        self.googleService = googleService
        self.kakaoService = kakaoService
        self.naverService = naverService
        self.appleService = appleService
        self.changeIsNewUserRepository = changeIsNewUserRepository
    }
    
    func emailRequest() -> Observable<LoginModel> {
        return Observable.create { [weak self] observer in
            self?.emailRepository.requestLogin { responseData in
                observer.onNext(responseData)
            } failure: { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func customLoginRequest() -> Observable<LoginModel> {
        return Observable.create { [weak self] observer in
            
            self?.emailRepository.requestCustomLogin { responseData in
                observer.onNext(responseData)
            } failure: { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func googleLoginStart(_ presenting: UIViewController) {
        googleService.requestGoogleLogin(presenting)
        getGoogleInfo()
    }
    
    func getGoogleInfo() {
        googleService.observableLoading()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.loadingState.accept(value)
            })
            .disposed(by: disposeBag)
        
        googleService.observableGoogleInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.googleInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoLoginStart() {
        kakaoService.requestKakaoLogin()
        getKakaoInfo()
    }
    
    func getKakaoInfo() {
        kakaoService.observableKakaoInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.kakaoInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func naverLoginStart() {
        naverService.requestNaverLogin()
        getNaverInfo()
    }
    
    func getNaverInfo() {
        naverService.observableLoading()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.loadingState.accept(value)
            })
            .disposed(by: disposeBag)
        
        naverService.observableNaverInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.naverInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func appleLoginStart() {
        appleService.requestAppleLogin()
        getAppleInfo()
    }
    
    func getAppleInfo() {
        appleService.observableAppleInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.appleInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func changeIsNewUserRequest(_ dto: ChangeIsNewUserDTO) -> Observable<ChangeIsNewUserModel> {
        return Observable.create { [weak self] observer in
            
            self?.changeIsNewUserRepository.requestChangeIsNewUser(dto: dto, success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
}
