//
//  LoginRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import RxSwift
import Alamofire

protocol LoginRepositoryProtocol {
    func requestLogin(success: @escaping (LoginModel) -> Void,
                      failure: @escaping (Error) -> Void)
    
    func requestCustomLogin(success: @escaping (LoginModel) -> Void,
                            failure: @escaping (Error) -> Void)
}

final class LoginRepository: LoginRepositoryProtocol {
    func requestLogin(success: @escaping (LoginModel) -> Void,
                      failure: @escaping (Error) -> Void) {
        NetworkClient.request(LoginModel.self,
                              router: Router.login) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
    
    func requestCustomLogin(success: @escaping (LoginModel) -> Void,
                            failure: @escaping (Error) -> Void) {
        NetworkClient.request(LoginModel.self,
                              router: Router.customLogin) { response in
            success(response)
        } failure: { error in
            failure(error)
        }

    }
}
