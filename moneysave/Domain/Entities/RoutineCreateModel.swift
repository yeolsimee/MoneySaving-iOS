//
//  RoutineCreateModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/15.
//

import Foundation

struct RoutineCreateModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: RoutineCreateData
}

struct RoutineCreateData: Codable {
    let routineId: Int
    let routineName: String
    let categoryName: String
    let categoryId: String
    let routineDayWeeks: [String]?
    let routineType: String
    let alarmStatus: String
    let alarmTime: String?
}
