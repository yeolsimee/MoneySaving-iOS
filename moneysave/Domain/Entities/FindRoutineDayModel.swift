//
//  FindRoutineDayModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/20.
//

import Foundation

struct FindRoutineDayModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: FindRoutineData
}

struct FindRoutineData: Codable {
    let routineDay: String
    let categoryDatas: [FindRoutineDatas]
}

struct FindRoutineDatas: Codable {
    let categoryId: String
    let categoryName: String
    let routineCheckedRate: Double
    let routineDatas: [FindRoutineList]
}

struct FindRoutineList: Codable {
    let routineId: Int
    let routineName: String
    let routineCheckYN: String
    let routineTimeZone: String
    let alarmTimeHour: String
    let alarmTimeMinute: String
    let alarmStatus: String
}
