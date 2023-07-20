//
//  LoginModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

struct LoginModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: LoginData?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

struct LoginData: Codable {
    let name: String
    let username: String
    let nickName: String?
    let gender: String?
    let phoneNumber: String?
    let isNewUser: String
}
//struct LoginData: Codable {
//    let name: String
//    let isNewUser: String
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case isNewUser = "isNewUser"
//    }
//}
