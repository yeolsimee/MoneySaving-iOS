//
//  RoutineAlarmListModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/06/02.
//

import Foundation

struct RoutineAlarmListModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: [RoutineAlarmListData]
}

struct RoutineAlarmListData: Codable {
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
