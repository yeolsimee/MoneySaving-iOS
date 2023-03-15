//
//  LoginRepository.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import Alamofire

protocol LoginRepositoryProtocol {
    func requestLogin(dto: LoginRequestDTO,
                      success: @escaping (LoginModel) -> Void,
                      failure: @escaping (Error) -> Void)
}

final class LoginRepository: LoginRepositoryProtocol {
    func requestLogin(dto: LoginRequestDTO,
                      success: @escaping (LoginModel) -> Void,
                      failure: @escaping (Error) -> Void) {
        NetworkClient.request(LoginModel.self,
                              router: Router.login(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
