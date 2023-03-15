//
//  IntroViewModel.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import RxSwift
import RxCocoa
import FirebaseFunctions

final class IntroViewModel {
    var coordinator: IntroCoordinator?
    var presentingView: UIViewController?
    
    private let introUseCase: IntroUseCase
    private lazy var functions = Functions.functions(region: "asia-northeast1")
    
    init(coordinator: IntroCoordinator,
         introUseCase: IntroUseCase,
         presentingView: UIViewController) {
        self.coordinator = coordinator
        self.introUseCase = introUseCase
        self.presentingView = presentingView
    }
    
    struct Input {
        let btnEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.btnEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                
            })
            .disposed(by: disposeBag)
        
        introUseCase.naverInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.test(data: value)
            })
            .disposed(by: disposeBag)
        
//        introUseCase.kakaoInfo
//            .observe(on: MainScheduler.asyncInstance)
//            .withUnretained(self)
//            .subscribe(onNext: { (view, value) in
//                view.test(data: value)
//            })
//            .disposed(by: disposeBag)
        
//        introUseCase.googleInfo
//            .observe(on: MainScheduler.asyncInstance)
//            .withUnretained(self)
//            .subscribe(onNext: { (view, state) in
//
//            })
//            .disposed(by: disposeBag)
        
        return output
    }
    
    func test(data: NaverUserInfo) {
        // kakao
//        functions.httpsCallable("kakaoCustomAuth").call(data.token.accessToken) { result, error in
//
//            if let error = error {
//                print("2818 \(error)")
//
//            }
//
//            if let res = result {
//                let resdic = res.data as? [String:Any]
//                let tt = resdic?["firebase_token"] as? String ?? "고장남"
//                print("2818 \(tt)")
//            }
//        }
        
        // naver
        functions.httpsCallable("naverCustomAuth").call(data.accessToken ?? "") { result, error in
            if let error = error {
                print("2818 \(error)")
            }
            
            if let res = result {
                let resdic = res.data as? [String:Any]
                let tt = resdic?["firebase_token"] as? String ?? "고장남"
                print("2818 \(tt)")
            }
        }
        
    }
}
