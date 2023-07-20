//
//  FindRoutineDayRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/20.
//

import UIKit
import RxSwift
import Alamofire

protocol FindAllRoutineDayProtocol {
    func requestFindAllRoutineDay(dto: FindAllRoutineDayDTO,
                               success: @escaping (FindAllRoutineDayModel) -> Void,
                               failure: @escaping (Error) -> Void)
}

final class FindAllRoutineDay: FindAllRoutineDayProtocol {
    func requestFindAllRoutineDay(dto: FindAllRoutineDayDTO,
                               success: @escaping (FindAllRoutineDayModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        NetworkClient.request(FindAllRoutineDayModel.self,
                              router: Router.findAllRoutineDay(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
