//
//  RoutineUpdateModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import Foundation

struct RoutineUpdateModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: RoutineUpdateData
}

struct RoutineUpdateData: Codable {
    let routineId: Int
    let routineName: String
    let categoryName: String
    let categoryId: String
    let weekTypes: [String]
    let routineType: String
    let alarmStatus: String
    let alarmTime: String
    let routineTimeZone: String
}
