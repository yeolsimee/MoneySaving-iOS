//
//  IntroUseCase.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol IntroUseCaseProtocol {
    func googleLoginStart(_ presenting: UIViewController)
    func kakaoLoginStart()
    func naverLoginStart()
}

final class IntroUseCase: IntroUseCaseProtocol {
    private let googleService: GoogleServiceProtocol
    private let kakaoService: KakaoServiceProtocol
    private let naverService: NaverServiceProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var googleInfo: PublishRelay<Bool> = PublishRelay()
    var kakaoInfo: PublishRelay<KakaoUserInfo> = PublishRelay()
    var naverInfo: PublishRelay<NaverUserInfo> = PublishRelay()
    
    init(googleService: GoogleServiceProtocol, kakaoService: KakaoServiceProtocol, naverService: NaverServiceProtocol) {
        self.googleService = googleService
        self.kakaoService = kakaoService
        self.naverService = naverService
    }
    
    func googleLoginStart(_ presenting: UIViewController) {
        googleService.requestGoogleLogin(presenting)
        getGoogleInfo()
    }
    
    func getGoogleInfo() {
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
        naverService.observableNaverInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.naverInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
}
