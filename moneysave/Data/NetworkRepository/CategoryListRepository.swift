//
//  CategoryListRepository.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/09.
//

import UIKit
import RxSwift
import Alamofire

protocol CategoryListProtocol {
    func requestCategoryList(success: @escaping (CategoryListModel) -> Void,
                             failure: @escaping (Error) -> Void)
}

final class CategoryList: CategoryListProtocol {
    func requestCategoryList(success: @escaping (CategoryListModel) -> Void,
                             failure: @escaping (Error) -> Void) {
        NetworkClient.request(CategoryListModel.self,
                              router: Router.categoryList) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
}
