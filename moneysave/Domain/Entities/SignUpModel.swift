//
//  SignUpModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

struct SignUpModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case code = "code"
        case message = "message"
    }
}
