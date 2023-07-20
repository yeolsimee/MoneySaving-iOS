//
//  RoutineGetModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/16.
//

import Foundation

struct RoutineGetModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: RoutineGetData
}

struct RoutineGetData: Codable {
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
