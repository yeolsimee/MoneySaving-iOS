//
//  ChangeIsNewUserRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/18.
//

import UIKit
import RxSwift
import Alamofire

protocol ChangeIsNewUserProtocol {
    func requestChangeIsNewUser(dto: ChangeIsNewUserDTO,
                                success: @escaping (ChangeIsNewUserModel) -> Void,
                                failure: @escaping (Error) -> Void)
}

final class ChangeIsNewUser: ChangeIsNewUserProtocol {
    func requestChangeIsNewUser(dto: ChangeIsNewUserDTO,
                                success: @escaping (ChangeIsNewUserModel) -> Void,
                                failure: @escaping (Error) -> Void) {
        NetworkClient.request(ChangeIsNewUserModel.self,
                              router: Router.changeIsNewUser(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
