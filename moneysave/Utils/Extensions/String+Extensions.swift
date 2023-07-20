//
//  String+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/23.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
        (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
            String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func toDate(_ format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
    
    func toDateFormat(format: String = "HH:mm", changeFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let date = dateFormatter.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = changeFormat
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    
    /**
     요일 Int전환
     > Status :
     일: 1, 월: 2, 화: 3, 수: 4, 목: 5, 금: 6, 토: 7
     */
    func toWeekInt() -> Int {
        switch self {
        case "SUNDAY":
            return 1
        case "MONDAY":
            return 2
        case "TUESDAY":
            return 3
        case "WEDNESDAY":
            return 4
        case "THURSDAY":
            return 5
        case "FRIDAY":
            return 6
        case "SATURDAY":
            return 7
        default:
            return 0
        }
    }
    
    func textMaxCount(count: Int) -> Bool {
        var text = self
        let maxCount = count + 1
        
        if self.count >= maxCount {
            return false
        } else {
            return true
        }
    }
    
    func emailValid() -> String {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let vali = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)

        if vali {
            return self
        }
        
        return ""
    }
    
    func toTimeZoneInt() -> Int {
        if self == "아무때나" {
            return 2
        } else if self == "아침" {
            return 3
        } else if self == "점심" {
            return 4
        } else if self == "저녁" {
            return 5
        } else if self == "밤" {
            return 6
        } else if self == "취침직전" {
            return 7
        } else if self == "기상직후" {
            return 8
        } else if self == "오전" {
            return 9
        } else if self == "오후" {
            return 10
        }
        
        return 1
    }
    
    func toWeekEn() -> String {
        if self == "화" {
            return "TUESDAY"
        } else if self == "수" {
            return "WEDNESDAY"
        } else if self == "목" {
            return "THURSDAY"
        } else if self == "금" {
            return "FRIDAY"
        } else if self == "토" {
            return "SATURDAY"
        } else if self == "일" {
            return "SUNDAY"
        }
        
        return "MONDAY"
    }
    
    func toWeekKo() -> String {
        if self == "TUESDAY" {
            return "화"
        } else if self == "WEDNESDAY" {
            return "수"
        } else if self == "THURSDAY" {
            return "목"
        } else if self == "FRIDAY" {
            return "금"
        } else if self == "SATURDAY" {
            return "토"
        } else if self == "SUNDAY" {
            return "일"
        }
        
        return "월"
    }
    
    func toTimeZone() -> String {
        if self == "2" {
            return "아무때나"
        } else if self == "3" {
            return "아침"
        } else if self == "4" {
            return "점심"
        } else if self == "5" {
            return "저녁"
        } else if self == "6" {
            return "밥"
        } else if self == "7" {
            return "취침직전"
        } else if self == "8" {
            return "기상직후"
        } else if self == "9" {
            return "오전"
        } else if self == "10" {
            return "오후"
        }
        
        return "하루종일"
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
