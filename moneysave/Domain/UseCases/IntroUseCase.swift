//
//  IntroUseCase.swift
//  moneysave
//
//  Created by 김민구 on 2023/07/12.
//

import Foundation
import RxSwift
import RxCocoa

final class IntroUseCase {
    private let emailRepository: LoginRepositoryProtocol
    
    init(emailRepository: LoginRepositoryProtocol) {
        self.emailRepository = emailRepository
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
}
