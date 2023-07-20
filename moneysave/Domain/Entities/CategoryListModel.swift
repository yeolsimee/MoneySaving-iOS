//
//  CategoryListModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/09.
//

import Foundation

struct CategoryListModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: [CategoryListData]
}

struct CategoryListData: Codable {
    let categoryId: String?
    let categoryName: String
}
