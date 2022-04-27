//
//  SearchResult.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/27.
//

import Foundation

struct SearchResult {
    let id: Int
    let name: String
    let nameEn: String
    let imageURL: String
    let type: String
}

struct SearchResultList {
    let title: String
    let description: String
    let statusCode: Int
    let results: [SearchResult]
}
