//
//  RoutineCheckModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/17.
//

import Foundation

struct RoutineCheckModel: Codable {
    let success: Bool
    let code: Int
    let message: String
//    let data: RoutineCheckData
}

struct RoutineCheckData: Codable {
    let routineHistoryId: Int
    let routineId: Int
    let routineDay: String
    let routineCheckYN: String
}
