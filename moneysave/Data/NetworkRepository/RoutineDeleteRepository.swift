//
//  RoutineDeleteRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/16.
//

import UIKit
import RxSwift
import Alamofire

protocol RoutineDeleteProtocol {
    func requestRoutineDelete(success: @escaping (RoutineDeleteModel) -> Void,
                              failure: @escaping (Error) -> Void)
}

final class RoutineDelegate: RoutineDeleteProtocol {
    func requestRoutineDelete(success: @escaping (RoutineDeleteModel) -> Void,
                              failure: @escaping (Error) -> Void) {
        NetworkClient.request(RoutineDeleteModel.self, router: Router.routineDelete) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
