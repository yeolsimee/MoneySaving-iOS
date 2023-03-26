//
//  String+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/23.
//

import Foundation

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
        (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
            String(self[substringFrom..<substringTo])
            }
        }
    }
    
    /**
     요일 Int전환
     > Status :
     일: 1, 월: 2, 화: 3, 수: 4, 목: 5, 금: 6, 토: 7
     */
    func toWeekInt() -> Int {
        switch self {
        case "일":
            return 1
        case "월":
            return 2
        case "화":
            return 3
        case "수":
            return 4
        case "목":
            return 5
        case "금":
            return 6
        case "토":
            return 7
        default:
            return 0
        }
    }
}
