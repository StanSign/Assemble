//
//  News.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

struct NewsResult {
    let statusCode: Int
    let title: String
    let description: String?
    let count: Int
    let results: [News]
}

struct News {
    let id: Int
    let type: NewsType
    let urlString: String
    let title: String
    let body: String?
    let thumbnail: String
}
