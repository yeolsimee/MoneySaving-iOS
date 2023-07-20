//
//  Date+Extensions.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

extension Date {
    /// 스트링 변환 : 날짜 포멧
    func toString(_ format:String, am:String? = nil, pm:String? = nil)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        
        if let amSymbol = am {
            dateFormatter.amSymbol = amSymbol
        }
        if let pmSymbol = pm {
            dateFormatter.pmSymbol = pmSymbol
        }
            
        return dateFormatter.string(from: self)
    }
    
    // 날짜 변환 : 날짜 포멧
    func toDateKoreaTime()-> Date {
        var today = Date()
        let format = "yyyyMMddHHmmssSSS"
        let date = self.toString(format)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        if let value = formatter.date(from:date) {
            today = value
        }
        
        return today
    }
    
    func getYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: Date())
    }
    
    func toDayTime(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        let result = dateFormatter.string(from: self)
        return result
    }
    
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = format
        let date = self.toString(format)
        return formatter.date(from: date)!
    }
}
