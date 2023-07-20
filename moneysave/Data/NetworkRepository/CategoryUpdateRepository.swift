//
//  CategoryUpdateRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/06/02.
//

import UIKit
import RxSwift
import Alamofire

protocol CategoryUpdateProtocol {
    func requestCategoryUpdate(dto: CategoryUpdateDTO,
                               success: @escaping (CategoryUpdateModel) -> Void,
                               failure: @escaping (Error) -> Void)
}

final class CategoryUpdate: CategoryUpdateProtocol {
    func requestCategoryUpdate(dto: CategoryUpdateDTO,
                               success: @escaping (CategoryUpdateModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        NetworkClient.request(CategoryUpdateModel.self,
                              router: Router.categoryUpdate(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }

    }
}
