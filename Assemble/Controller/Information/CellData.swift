//
//  InfoCellData.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/22.
//

import UIKit
import RxDataSources

struct SectionOfInfoCell {
    var items: [Item]
}

enum CellType {
    case headerCell(HeaderCellModel)
    case detailCell(DetailCellModel)
    case menuCell
    case none
}

extension SectionOfInfoCell: SectionModelType {
    typealias Item = CellType

    init(original: SectionOfInfoCell, items: [Item] = []) {
        self = original
        self.items = items
    }
}

struct HeaderCellModel {
    var id: Int
    var type: String
    var headLabel: String
    var subHeadLabel: String
    var childImage1: String?
    var childImage2: String?
    var childImage3: String?
    var childLabel1: String?
    var childLabel2: String?
    var childLabel3: String?
}

struct DetailCellModel {
    var body: String?
}
