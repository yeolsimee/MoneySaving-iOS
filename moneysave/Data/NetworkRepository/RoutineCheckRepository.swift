//
//  RoutineCheckRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import Foundation

protocol RoutineCheckProtocol {
    func requestRoutineCheck(dto: RoutineCheckDTO,
                             success: @escaping (RoutineCheckModel) -> Void,
                             failure: @escaping (Error) -> Void)
}

final class RoutineCheck: RoutineCheckProtocol {
    func requestRoutineCheck(dto: RoutineCheckDTO,
                             success: @escaping (RoutineCheckModel) -> Void,
                             failure: @escaping (Error) -> Void) {
        NetworkClient.request(RoutineCheckModel.self,
                              router: Router.routineCheck(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
