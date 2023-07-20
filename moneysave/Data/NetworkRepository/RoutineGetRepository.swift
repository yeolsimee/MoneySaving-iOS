//
//  RoutineGetRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/16.
//

import UIKit
import RxSwift
import RxCocoa

protocol RoutineGetProtocol {
    func requestRoutineGet(success: @escaping (RoutineGetModel) -> Void,
                           failure: @escaping (Error) -> Void)
}

final class RoutineGet: RoutineGetProtocol {
    func requestRoutineGet(success: @escaping (RoutineGetModel) -> Void,
                           failure: @escaping (Error) -> Void) {
        NetworkClient.request(RoutineGetModel.self,
                              router: Router.routineGet) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
