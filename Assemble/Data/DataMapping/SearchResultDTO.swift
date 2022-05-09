//
//  SearchResultDTO.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/26.
//

import Foundation

struct SearchResultDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case statusCode
        case title
        case description
        case results
    }
    let statusCode: Int
    let title: String
    let description: String
    let results: [ResultDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.results = try container.decode([ResultDTO].self, forKey: .results)
    }
}

extension SearchResultDTO {
    struct ResultDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case nameEn = "name_En"
            case imageURL = "image"
            case type
        }
        let id: Int
        let name: String?
        let nameEn: String
        let imageURL: String?
        let type: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String?.self, forKey: .name)
            self.nameEn = try container.decode(String.self, forKey: .nameEn)
            self.imageURL = try container.decode(String?.self, forKey: .imageURL)
            self.type = try container.decode(String.self, forKey: .type)
        }
    }
}

//MARK: - Mapping to Domain

extension SearchResultDTO {
    func toDomain() -> SearchResultList {
        return .init(title: title,
                     description: description,
                     statusCode: statusCode,
                     results: results.map { $0.toDomain() })
    }
}

extension SearchResultDTO.ResultDTO {
    func toDomain() -> SearchResult {
        return .init(id: id,
                     name: name ?? "",
                     nameEn: nameEn,
                     imageURL: imageURL ?? "",
                     type: type
        )
    }
}
