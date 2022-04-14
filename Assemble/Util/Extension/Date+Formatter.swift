//
//  Date+Formatter.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/13.
//

import Foundation

extension Date {
    func dateToString(from date: Date) -> String {
        let formatter = getKoreanFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    func getKoreanFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
}
