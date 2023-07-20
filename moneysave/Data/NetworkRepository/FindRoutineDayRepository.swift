//
//  FindRoutineDayRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/20.
//

import UIKit
import RxSwift
import Alamofire

protocol FindRoutineDayProtocol {
    func requestFindRoutineDay(dto: FindRoutineDayDTO,
                               success: @escaping (FindRoutineDayModel) -> Void,
                               failure: @escaping (Error) -> Void)
}

final class FindRoutineDay: FindRoutineDayProtocol {
    func requestFindRoutineDay(dto: FindRoutineDayDTO,
                               success: @escaping (FindRoutineDayModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        NetworkClient.request(FindRoutineDayModel.self,
                              router: Router.findRoutineDay(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}

