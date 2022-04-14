//
//  String+Formatter.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/13.
//

import UIKit

extension String {
    enum SplitCase {
        case head, tail
    }
    
    func splitAndGet(_ part: SplitCase, by characterSet: CharacterSet) -> String {
        let result = self.components(separatedBy: characterSet)
        switch part {
        case .head:
            return result.first ?? ""
        case .tail:
            if result.last == nil {
                return ""
            } else if result.first == result.last {
                return ""
            } else {
                return result.last!
            }
        }
    }
    
    func stringToDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.date(from: string)
    }
    
    func getStateFromReleaseDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let targetDate = formatter.date(from: self)
        let timeInterval = (targetDate?.timeIntervalSinceNow)!
        let D_Day = Int(timeInterval) / 86400
        
        switch D_Day {
        case Int.min ..< 0:
            return "상영 중"
        case 0 ..< Int.max:
            return "D-\(abs(D_Day))"
        case 0:
            return "오늘 개봉"
        default:
            return "개봉 날짜 미정"
        }
    }
    
    func fetchImageFromString() -> UIImage {
        return UIImage()
    }
}
