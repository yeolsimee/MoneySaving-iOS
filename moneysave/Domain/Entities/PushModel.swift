//
//  PushModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/06/02.
//

import Foundation

struct PushModel: Codable {
    var id: String
    var day: [String]
    var hour: String
    var min: String
    var second: String
    var title: String
    var msg: String
}
