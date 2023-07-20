//
//  Int+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/23.
//

import Foundation

extension Int {
    func toTimeZone() -> String {
        if self == 2 {
            return "아무때나"
        } else if self == 3 {
            return "아침"
        } else if self == 4 {
            return "점심"
        } else if self == 5 {
            return "저녁"
        } else if self == 6 {
            return "밤"
        } else if self == 7 {
            return "취침직전"
        } else if self == 8 {
            return "기상직후"
        } else if self == 9 {
            return "오전"
        } else if self == 10 {
            return "오후"
        }
        
        
        return "하루종일"
    }
}
