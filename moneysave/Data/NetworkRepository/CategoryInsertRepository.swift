//
//  CategoryInsertRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import UIKit
import RxSwift
import Alamofire

protocol CategoryInsertProtocol {
    func requestCategoryInsert(dto: CategoryInsertDTO,
                               success: @escaping (CategoryInsertModel) -> Void,
                               failure: @escaping (Error) -> Void)
}

final class CategoryInsert: CategoryInsertProtocol {
    func requestCategoryInsert(dto: CategoryInsertDTO,
                               success: @escaping (CategoryInsertModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        NetworkClient.request(CategoryInsertModel.self,
                              router: Router.categoryInsert(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
