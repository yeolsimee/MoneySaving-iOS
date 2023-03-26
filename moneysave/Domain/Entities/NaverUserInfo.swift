//
//  NaverUserInfo.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

struct NaverUserInfo: Codable {
    let ci: String?
    let name: String?
    let email: String?
    let nickName: String?
    let birthDay: String?
    let profilImg: String?
    let gender: String?
    let id: String?
    let code: String?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case ci = "ci"
        case name = "name"
        case email = "email"
        case nickName = "nickname"
        case birthDay = "birthday"
        case profilImg = "profile_image"
        case gender = "gender"
        case id = "id"
        case code = "resultCode"
        case accessToken = "accessToken"
    }
}
