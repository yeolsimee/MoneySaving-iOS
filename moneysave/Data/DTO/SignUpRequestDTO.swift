//
//  SignUpRequestDTO.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let username: String
    let name: String
    let password: String
    let email: String
    let phoneNumber: String
    let birtday: String
    let address: String
}
