//
//  RoutineUpdateRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol RoutineUpdateProtocol {
    func requestRoutineUpdate(dto: RoutineUpdateDTO,
                              success: @escaping (RoutineUpdateModel) -> Void,
                              failure: @escaping (Error) -> Void)
}

final class RoutineUpdate: RoutineUpdateProtocol {
    func requestRoutineUpdate(dto: RoutineUpdateDTO,
                              success: @escaping (RoutineUpdateModel) -> Void,
                              failure: @escaping (Error) -> Void) {
        NetworkClient.request(RoutineUpdateModel.self,
                              router: Router.routineUpdate(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
