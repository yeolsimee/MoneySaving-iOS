//
//  SignUpRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import RxSwift
import Alamofire

protocol SignUpRepositoryProtocol {
    func requestSignUp(dto: SignUpRequestDTO,
                       success: @escaping (SignUpModel) -> Void,
                       failure: @escaping (Error) -> Void)
}

final class SignUpRepository: SignUpRepositoryProtocol {
    func requestSignUp(dto: SignUpRequestDTO,
                       success: @escaping (SignUpModel) -> Void,
                       failure: @escaping (Error) -> Void) {
        NetworkClient.request(SignUpModel.self,
                              router: Router.signUp(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
