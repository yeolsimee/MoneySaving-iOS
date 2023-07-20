//
//  WithDrawRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/18.
//

import UIKit
import RxSwift
import Alamofire

protocol WithDrawProtocol {
    func requestWithDraw(success: @escaping (WithDrawModel) -> Void,
                         failure: @escaping (Error) -> Void)
}

final class WithDraw: WithDrawProtocol {
    func requestWithDraw(success: @escaping (WithDrawModel) -> Void,
                         failure: @escaping (Error) -> Void) {
        NetworkClient.request(WithDrawModel.self,
                              router: Router.withDraw) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
