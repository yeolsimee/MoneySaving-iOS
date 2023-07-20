//
//  RoutineCreateRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/15.
//

import UIKit
import RxSwift
import Alamofire

protocol RoutineCreateProtocol {
    func requestRoutineCreate(dto: RoutineCreateDTO,
                              success: @escaping (RoutineCreateModel) -> Void,
                              failure: @escaping (Error) -> Void)
}

final class RoutineCreate: RoutineCreateProtocol {
    func requestRoutineCreate(dto: RoutineCreateDTO,
                              success: @escaping (RoutineCreateModel) -> Void,
                              failure: @escaping (Error) -> Void) {
        NetworkClient.request(RoutineCreateModel.self,
                              router: Router.routineCreate(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
