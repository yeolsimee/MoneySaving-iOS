//
//  CategoryInsertModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/10.
//

import Foundation

struct CategoryInsertModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: CategoryInsertData
}

struct CategoryInsertData: Codable {
    let categoryId: String
    let categoryName: String
}
