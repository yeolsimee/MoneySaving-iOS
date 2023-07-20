//
//  RoutineUpdateDTO.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/16.
//

import Foundation

struct RoutineUpdateDTO: Codable {
    let alarmStatus: String
    let routineType: String
    let alarmTime: String
    let routineName: String
    let categoryId: String
    let weekTypes: [String]
    let routineTimeZone: String
}
