//
//  KakaoService.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKCommon

protocol KakaoServiceProtocol {
    func requestKakaoLogin()
    func observableKakaoInfo() -> Observable<KakaoUserInfo>
}

final class KakaoService: KakaoServiceProtocol {
    var disposeBag: DisposeBag = DisposeBag()
    var kakaoInfo: PublishRelay<KakaoUserInfo> = PublishRelay()
    
    func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .withUnretained(self)
                .subscribe(onNext: { (view, token) in
                    DispatchQueue.main.async {
                        view.getKakaoInfo(token: token)
                    }
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .withUnretained(self)
                .subscribe(onNext: { (view, token) in
                    DispatchQueue.main.async {
                        view.getKakaoInfo(token: token)
                    }
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func observableKakaoInfo() -> Observable<KakaoUserInfo> {
        return kakaoInfo.asObservable()
    }
    
    private func getKakaoInfo(token: OAuthToken) {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                let info = KakaoUserInfo(id: user.id ?? Int64(0),
                                         nickname: user.kakaoAccount?.profile?.nickname ?? "",
                                         token: token)
                self?.kakaoInfo.accept(info)
            }, onFailure: { error in
                print("Kakao UserApi.shared.rx.me onFailure")
            })
            .disposed(by: disposeBag)
    }
}
