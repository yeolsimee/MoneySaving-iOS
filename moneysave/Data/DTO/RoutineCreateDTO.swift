//
//  RoutineCreateDTO.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/15.
//

import Foundation

struct RoutineCreateDTO: Codable {
    let alarmStatus: String
    let routineType: String
    let alarmTime: String
    let routineName: String
    let categoryId: String
    let weekTypes: [String]
    let routineTimeZone: String
}
