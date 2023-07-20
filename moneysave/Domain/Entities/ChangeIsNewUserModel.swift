//
//  ChangeIsNewUserModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/18.
//

import Foundation

struct ChangeIsNewUserModel: Codable {
    let success: Bool
    let code: Int
    let message: String
}

struct ChangeIsNewUserData: Codable {
    let name: String
    let username: String
    let nickname: String?
    let gender: String?
    let phoneNumber: String?
    let birthday: String?
    let isNewUser: String
}
