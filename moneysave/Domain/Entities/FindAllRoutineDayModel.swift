//
//  FindRoutineDayModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/19.
//

import Foundation

struct FindAllRoutineDayModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: FindAllRoutinData
}

struct FindAllRoutinData: Codable {
    let routineDays: [FindAllRoutineDayDatas]
}

struct FindAllRoutineDayDatas: Codable {
    let day: String
    let routineAchievement: String
}
