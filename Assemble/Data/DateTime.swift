//
//  DateTime.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/03.
//

import Foundation

class DateTime {
    
    public func date2String(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    public func string2Date(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: string)
    }
    
    public func getNowDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        return dateFormatter.string(from: now)
    }
    
    public func calculateDday(fromDate: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko")
        
        let targetDate = dateFormatter.date(from: fromDate)!
        let formattedNow = dateFormatter.string(from: Date())
        let now = string2Date(string: formattedNow)!
        
        let timeInterval = targetDate.timeIntervalSince(now)
        let D_Day = Int(timeInterval) / 86400
        
        return D_Day
    }
}
