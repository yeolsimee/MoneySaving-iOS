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
}

final class IntroUseCase: IntroUseCaseProtocol {
    private let googleService: GoogleServiceProtocol
    
    private let disposeBag = DisposeBag()
    
    var googleInfo: PublishRelay<Bool> = PublishRelay()
    init(googleService: GoogleServiceProtocol) {
        self.googleService = googleService
    }
    
    func googleLoginStart(_ presenting: UIViewController) {
        googleService.requestGoogleLogin(presenting)
        getGoogleInfo()
    }
    
    func getGoogleInfo() {
        googleService.observableGoogleInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, state) in
                view.googleInfo.accept(state)
            })
            .disposed(by: disposeBag)
    }
}
