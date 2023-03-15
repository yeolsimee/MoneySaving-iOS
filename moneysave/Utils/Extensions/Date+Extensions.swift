//
//  Date+Extensions.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation

extension Date {
    /// 스트링 변환 : 날짜 포멧
    func toString(_ format:String, am:String? = nil, pm:String? = nil)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
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
        formatter.timeZone = TimeZone(secondsFromGMT: -9 * 60 * 60)
        if let value = formatter.date(from:date) {
            today = value
        }
        
        return today
    }
}
