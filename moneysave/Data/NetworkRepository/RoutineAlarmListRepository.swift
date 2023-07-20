//
//  RoutineAlarmListRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/06/02.
//

import UIKit
import RxSwift
import Alamofire

protocol RoutineAlarmListProtocol {
    func requestRoutineAlarmList(success: @escaping (RoutineAlarmListModel) -> Void,
                                 failure: @escaping (Error) -> Void)
}

final class RoutineAlarmList: RoutineAlarmListProtocol {
    func requestRoutineAlarmList(success: @escaping (RoutineAlarmListModel) -> Void,
                                 failure: @escaping (Error) -> Void) {
        
        NetworkClient.request(RoutineAlarmListModel.self,
                              router: Router.routineAlarmList) { response in
            success(response)
        } failure: { error in
            failure(error)
        }

    }
}
