//
//  APIModels.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

extension AssembleAPIManager {
    
    struct SearchResult: Codable {
        var statusCode: Int
        var title: String
        var results: [Search]
        var description: String
    }
    
    struct Search: Codable {
        var id: Int
        var name: String?
        var name_En: String
        var image: String?
        var type: String
    }
}
