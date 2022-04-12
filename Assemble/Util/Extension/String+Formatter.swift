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
            if result.first != result.last {
                return result.last ?? ""
            }
            return ""
        }
    }
}
