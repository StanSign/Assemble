//
//  FrontComposition.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/10.
//

import UIKit

struct FrontComposition {
    static var frontComposition: [FrontCell] {
        return [
                // height //typeOfCell //classOfCell
            FrontCell(208, .NewsCell, NewsCell()),
            FrontCell(138, .HeroCell, HeroCell())
        ]
    }
    
    static var heroCellCharacters: [Heroes] {
        return [
            Heroes("스파이더맨", "spider-man"),
            Heroes("아이언맨", "iron-man"),
            Heroes("캡틴 아메리카", "captain-america"),
            Heroes("배트맨", "bat-man")
        ]
    }
}

class FrontCell {
    enum CellType: String {
        case HeroCell
        case NewsCell
        case PlaceHolderCell
    }
    
    var height: CGFloat
    var typeOfCell: CellType
    var classOfCell: NSObject
    
    init(_ height: CGFloat = 450, _ typeOfCell: CellType = .PlaceHolderCell, _ classOfCell: NSObject) {
        self.height = height
        self.typeOfCell = typeOfCell
        self.classOfCell = classOfCell
    }
}

class Heroes {
    enum Heroes: String {
        case ironman
        case spiderman
        case captainAmerica
        case batman
    }
    
    var name: String
    var nameEn: String
    
    init(_ name: String, _ nameEn: String) {
        self.name = name
        self.nameEn = nameEn
    }
}
