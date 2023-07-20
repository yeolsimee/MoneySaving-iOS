//
//  CategoryDeleteRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import UIKit
import RxSwift
import Alamofire

protocol CategoryDeleteProtocol {
    func requestCategoryDelete(dto: CategoryDeleteDTO,
                               success: @escaping (CategoryDeleteModel) -> Void,
                               failure: @escaping (Error) -> Void)
}

final class CategoryDelete: CategoryDeleteProtocol {
    func requestCategoryDelete(dto: CategoryDeleteDTO,
                               success: @escaping (CategoryDeleteModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        NetworkClient.request(CategoryDeleteModel.self,
                              router: Router.categoryDelete(dto: dto)) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
