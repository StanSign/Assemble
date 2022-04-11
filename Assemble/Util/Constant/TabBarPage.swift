//
//  TabBarPage.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/11.
//

enum TabBarPage: String, CaseIterable {
    case first
    case home
    case last
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .first
        case 1:
            self = .home
        case 2:
            self = .last
        default:
            return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .first:
            return 0
        case .home:
            return 1
        case .last:
            return 2
        }
    }
    
    // Add Tab Icon Value
    
    // Add Tab Icon Selected / Deselected Color
    
}
